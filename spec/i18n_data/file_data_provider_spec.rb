require File.join(File.dirname(__FILE__),'..',"spec_helper")
require 'i18n_data/file_data_provider'

describe I18NData::FileDataProvider do
  before do
    `rm -f #{I18NData::FileDataProvider.send(:cache_for,"XX","YY")}`
  end

  def read(x,y)
    I18NData::FileDataProvider.translated_or_english(x,y)
  end

  it "preserves data when writing and then reading" do
    data = {"x"=>"y","z"=>"w"}
    I18NData::FileDataProvider.send(:write_to_file,data,"XX","YY")
    read("XX","YY").should == data
  end

  it "does not write empty data sets" do
    I18NData::FileDataProvider.send(:write_to_file,{},"XX","YY")
    lambda{read("XX","YY")}.should raise_error I18NData::NoTranslationAvailable
  end
end