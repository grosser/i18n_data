# encoding: utf-8
require "spec_helper"

NUM_2_LETTER_LANGUAGES = 185
NUM_COUNTRIES = 249

describe I18nData do
  require "i18n_data/live_data_provider"
  require "i18n_data/file_data_provider"

  def blank_keys_or_values(hash)
    hash.detect{|k,v| k.to_s.empty? or v.to_s.empty?}
  end

  [I18nData::FileDataProvider, I18nData::LiveDataProvider].each do |provider|
    describe "using #{provider}" do
      before :all do
        I18nData.data_provider = provider
      end

      describe ".languages" do
        it "raises NoTranslationAvailable for unavailable languages" do
          lambda{I18nData.languages('XX')}.should raise_error(I18nData::NoTranslationAvailable)
        end

        it "is cached" do
          id = I18nData.languages.object_id
          I18nData.languages.object_id.should == id
          I18nData.languages("DE").object_id.should_not == id
        end

        describe "english" do
          it "does not contain blanks" do
            blank_keys_or_values(I18nData.languages).should == nil
          end

          it "has english as default" do
            I18nData.languages['DE'].should == 'German'
          end

          it "contains all languages" do
            I18nData.languages.size.should == NUM_2_LETTER_LANGUAGES
          end
        end

        describe "translated" do
          it "is translated" do
            I18nData.languages('DE')['DE'].should == 'Deutsch'
          end

          it "contains all languages" do
            I18nData.languages('DE').size.should == NUM_2_LETTER_LANGUAGES
          end

          it "has english names for not-translateable languages" do
            I18nData.languages('IS')['HA'].should == I18nData.languages['HA']
          end

          it "does not contain blanks" do
            blank_keys_or_values(I18nData.languages('GL')).should == nil
          end

          it "is written in unicode" do
            I18nData.languages('DE')['DA'].should == 'Dänisch'
          end

          it "has default for languages that only have subtypes" do
            I18nData.languages('ZH')['DA'].should == '丹麦语'
          end

          it "has language subtypes" do
            I18nData.languages('zh_TW')['DA'].should == '丹麥語'
          end
        end
      end

      describe ".countries" do
        it "is cached" do
          id = I18nData.countries.object_id
          I18nData.countries.object_id.should == id
          I18nData.countries("DE").object_id.should_not == id
        end

        describe "english" do
          it "has english as default" do
            I18nData.countries['DE'].should == 'Germany'
          end

          it "does not contain blanks" do
            blank_keys_or_values(I18nData.countries).should == nil
          end

          it "contains all countries" do
            I18nData.countries.size.should == NUM_COUNTRIES
          end
        end

        describe "translated" do
          it "is translated" do
            I18nData.countries('DE')['DE'].should == 'Deutschland'
          end

          it "contains all countries" do
            I18nData.countries('DE').size.should == NUM_COUNTRIES
          end

          it "has english names for not-translateable countries" do
            I18nData.countries('IS')['PK'].should == I18nData.countries['PK']
          end

          it "does not contain blanks" do
            blank_keys_or_values(I18nData.countries('GL')).should == nil
          end

          it "is written in unicode" do
            I18nData.countries('DE')['DK'].should == 'Dänemark'
          end

          it "has default for languages that only have subtypes" do
            I18nData.countries('ZH')['DK'].should == '丹麦'
            I18nData.countries('BN')['DK'].should == 'ডেনমার্ক'
          end

          it "has language subtypes" do
            I18nData.countries('zh_TW')['DK'].should == '丹麥'
          end
        end
      end
    end
  end

  describe :country_code do
    before :all do
      I18nData.data_provider = I18nData::FileDataProvider
    end

    it "recognises a countries name" do
      I18nData.country_code('Germany').should == 'DE'
    end

    it "recognises with blanks" do
      I18nData.country_code("   Germany \n\r ").should == 'DE'
    end

    it "returns nil when it cannot recognise" do
      I18nData.country_code('XY').should == nil
    end
  end

  describe :language_code do
    before :all do
      I18nData.data_provider = I18nData::FileDataProvider
    end

    it "recognises a countries name" do
      I18nData.language_code('Deutsch').should == 'DE'
    end

    it "recognizes languages that are ; seperated" do
      I18nData.language_code('Dutch').should == 'NL'
      I18nData.language_code('Flemish').should == 'NL'
    end

    it "recognises with blanks" do
      I18nData.language_code("   Deutsch \n\r ").should == 'DE'
    end

    it "returns nil when it cannot recognise" do
      I18nData.language_code('XY').should == nil
    end
  end

  it "has a VERSION" do
    I18nData::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
end
