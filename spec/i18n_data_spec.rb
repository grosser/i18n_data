require File.expand_path("spec_helper", File.dirname(__FILE__))

NUM_2_LETTER_LANGUAGES = 185
NUM_COUNTRIES = 246

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
    end
  end
  describe :countries do
    describe :english do
      it "has english as default" do
        I18NData.countries['DE'].should == 'Germany'
      end
      it "does not contain blanks" do
        I18NData.countries.detect {|k,v| k.blank? or v.blank?}.should == nil
      end
      it "contains all countries" do
        I18NData.countries.size.should == NUM_COUNTRIES
      end
    end
    describe :translated do
      it "is translated" do
        I18NData.countries('DE')['DE'].should == 'Deutschland'
      end
      it "contains all countries" do
        I18NData.countries('DE').size.should == NUM_COUNTRIES
      end
      it "has english names for not-translateable countries" do
        I18NData.countries('IS')['PK'].should == I18NData.countries['PK']
      end
      it "does not contain blanks" do
        I18NData.countries('GL').detect {|k,v| k.blank? or v.blank?}.should == nil
      end
      it "is written in unicode" do
        I18NData.countries('DE')['DK'].should == 'Dänemark'
      end
    end
  end
  describe :po_to_hash do
    def po_to_hash(text)
      I18NData.send(:po_to_hash,text)
    end
    it "parses po file into translations" do
      text = <<EOF
# come comment msgstr
msgid "one"
msgstr "1"
EOF
      po_to_hash(text).should == {"one"=>"1"}
    end
    it "keeps order of translations" do
      text = <<EOF
msgid "one"
msgstr "1"
msgid "two"
msgstr ""
msgid "three"
msgstr "3"
EOF
      po_to_hash(text).should == {"one"=>"1","two"=>"","three"=>"3"}
    end
    pending_it "finds x-line long translations" do
      text = <<EOF
#. name for chu, cu
msgid ""
"Church Slavic; Old Slavonic; Church Slavonic; Old Bulgarian; Old Church "
"Slavonic"
msgstr "Kirchenslavisch"
EOF
      long_name = "Church Slavic; Old Slavonic; Church Slavonic; Old Bulgarian; Old Church Slavonic"
      po_to_hash(text)[long_name].should == "Kirchenslavisch"
    end
  end
end