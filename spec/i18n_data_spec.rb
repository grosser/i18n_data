require File.expand_path("spec_helper", File.dirname(__FILE__))

NUM_2_LETTER_LANGUAGES = 185

describe I18NData do
  describe :languages do
    it "raises NoOnlineTranslationAvaiable for unavailable languages" do
      lambda{I18NData.languages('XX')}.should raise_error(I18NData::NoOnlineTranslationAvaiable)
    end
    describe :english do
      it "does not contain blanks" do
        I18NData.languages.detect {|k,v| k.blank? or v.blank?}.should == nil
      end
      it "has english as default" do
        I18NData.languages['DE'].should == 'German'
      end
      it "contains all languages" do
        I18NData.languages.size.should == NUM_2_LETTER_LANGUAGES
      end
    end
    describe :translated do
      it "is translated" do
        I18NData.languages('DE')['DE'].should == 'Deutsch'
      end
      it "contains all languages" do
        I18NData.languages('DE').size.should == NUM_2_LETTER_LANGUAGES
      end
      it "has english names for not-translateable languages" do
        I18NData.languages('IS')['HA'].should == I18NData.languages['HA']
      end
      it "does not contain blanks" do
        I18NData.languages('GL').detect {|k,v| k.blank? or v.blank?}.should == nil
      end
      it "is written in unicode" do
        I18NData.languages('DE')['DA'].should == 'Dänisch'
      end
      pending_it "finds x-line long gettext translations" do
        # TODO ? only entry too long to be parsed by a simple regex...
        #. name for chu, cu
        # msgid ""
        # "Church Slavic; Old Slavonic; Church Slavonic; Old Bulgarian; Old Church "
        # "Slavonic"
        I18NData.languages('DE')['CU'].should == 'Kirchenslavisch'
      end

    end
  end
end