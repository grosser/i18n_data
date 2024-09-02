# frozen_string_literal: true
require "spec_helper"

NUM_2_LETTER_LANGUAGES = 184
NUM_COUNTRIES = 249

describe I18nData do
  require "i18n_data/live_data_provider"
  require "i18n_data/file_data_provider"

  def blank_keys_or_values(hash)
    hash.detect { |k, v| k.to_s.empty? or v.to_s.empty? }
  end

  around do |t|
    old = I18nData.data_provider
    t.call
  ensure
    I18nData.data_provider = old
  end

  describe ".data_provider" do
    it "get the current provider" do
      I18nData.data_provider.should eq I18nData::FileDataProvider
    end

    it "sets a custom provider" do
      some_data_provider     = double(:data_provider)
      I18nData.data_provider = some_data_provider

      I18nData.data_provider.should eq some_data_provider
    end
  end

  [I18nData::FileDataProvider, I18nData::LiveDataProvider].each do |provider|
    describe "using #{provider}" do
      before :all do
        I18nData.data_provider = provider
      end

      describe ".languages" do
        it "raises NoTranslationAvailable for unavailable languages" do
          -> { I18nData.languages('XX') }.should raise_error(I18nData::NoTranslationAvailable)
        end

        it "is cached" do
          id = I18nData.languages.object_id
          I18nData.languages.object_id.should eq id
          I18nData.languages("DE").object_id.should_not eq id
        end

        describe "english" do
          it "does not contain blanks" do
            blank_keys_or_values(I18nData.languages).should be_nil
          end

          it "has english as default" do
            I18nData.languages['DE'].should eq 'German'
          end

          it "contains all languages" do
            I18nData.languages.size.should eq NUM_2_LETTER_LANGUAGES
          end
        end

        describe "translated" do
          it "is translated" do
            I18nData.languages('DE')['DE'].should eq 'Deutsch'
          end

          it "contains all languages" do
            I18nData.languages('DE').size.should eq NUM_2_LETTER_LANGUAGES
          end

          it "has english names for not-translateable languages" do
            I18nData.languages('IS')['HA'].should eq I18nData.languages['HA']
          end

          it "does not contain blanks" do
            blank_keys_or_values(I18nData.languages('GL')).should be_nil
          end

          it "is written in unicode" do
            I18nData.languages('DE')['DA'].should eq 'Dänisch'
          end

          it "has default for languages that only have subtypes" do
            I18nData.languages('ZH')['DA'].should eq '丹麦语'
          end

          it "has language subtypes" do
            I18nData.languages('zh_TW')['DA'].should eq '丹麥語'
          end

          it "has language scripts" do
            I18nData.languages('SR@LATIN')['DA'].should eq 'danski'
          end
        end
      end

      describe ".countries" do
        it "is cached" do
          id = I18nData.countries.object_id
          I18nData.countries.object_id.should eq id
          I18nData.countries("DE").object_id.should_not eq id
        end

        describe "english" do
          it "has english as default" do
            I18nData.countries['DE'].should eq 'Germany'
          end

          it "does not contain blanks" do
            blank_keys_or_values(I18nData.countries).should be_nil
          end

          it "contains all countries" do
            I18nData.countries.size.should eq NUM_COUNTRIES
          end

          it "shows countries names with apostrophes" do
            I18nData.countries['LA'].should eq "Laos"
          end
        end

        describe "translated" do
          it "is translated" do
            I18nData.countries('DE')['DE'].should eq 'Deutschland'
          end

          it "contains all countries" do
            I18nData.countries('DE').size.should eq NUM_COUNTRIES
          end

          it "has english names for not-translateable countries" do
            I18nData.countries('IS')['PK'].should eq I18nData.countries['PK']
          end

          it "prefers 'Common name for' when available" do
            I18nData.countries('PT')['MD'].should eq "Moldávia"
          end

          it "prefers 'Name for' as a fallback to 'Common name for'" do
            I18nData.countries('PT')['MV'].should eq "Maldivas"
          end

          it "ignores 'fuzzy' .po entries" do
            I18nData.countries('AF')['MK'].should eq "North Macedonia"
          end

          it "does not contain blanks" do
            blank_keys_or_values(I18nData.countries('GL')).should be_nil
          end

          it "is written in unicode" do
            I18nData.countries('DE')['DK'].should eq 'Dänemark'
          end

          it "has default for languages that only have subtypes" do
            I18nData.countries('ZH')['DK'].should eq '丹麦'
            I18nData.countries('BN')['DK'].should eq 'ডেনমার্ক'
          end

          it "has language subtypes" do
            I18nData.countries('zh_TW')['DK'].should eq '丹麥'
          end

          it "has language scripts" do
            I18nData.countries('SR@LATIN')['DK'].should eq 'Danska'
          end
        end
      end
    end
  end

  describe :country_code do
    around do |t|
      old = I18nData.data_provider
      I18nData.data_provider = I18nData::FileDataProvider
      t.call
    ensure
      I18nData.data_provider = old
    end

    it "recognises a countries name" do
      I18nData.country_code('Germany').should eq 'DE'
    end

    it "recognises with blanks" do
      I18nData.country_code("   Germany \n\r ").should eq 'DE'
    end

    it "returns nil when it cannot recognise" do
      I18nData.country_code('XY').should be_nil
    end

    it "can find languages that are not in english list" do
      I18nData.country_code('奧蘭群島').should eq 'AX'
    end
  end

  describe :language_code do
    before :all do
      I18nData.data_provider = I18nData::FileDataProvider
    end

    it "recognises a countries name" do
      I18nData.language_code('Deutsch').should eq 'DE'
    end

    it "recognizes languages that are ; seperated" do
      I18nData.language_code('Dutch').should eq 'NL'
      I18nData.language_code('Flemish').should eq 'NL'
    end

    it "recognizes full language name with ;" do
      I18nData.language_code("Kirghiz; Kyrgyz").should eq 'KY'
    end

    it "recognises with blanks" do
      I18nData.language_code("   Deutsch \n\r ").should eq 'DE'
    end

    it "returns nil when it cannot recognise" do
      I18nData.language_code('XY').should be_nil
    end
  end

  it "has a VERSION" do
    I18nData::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
end
