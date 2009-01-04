require File.expand_path("spec_helper", File.dirname(__FILE__))

describe I18NData do
  describe :languages do
    it "has english as default" do
      I18NData.languages['DE'].should == 'German'
    end
    it "contains all languages" do
      I18NData.languages.size.should == 186
    end
    pending_it "is written in unicode" do
      I18nData.language('DE')['DE'].should == 'Südaltaisch'
    end
  end
end