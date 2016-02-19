require "spec_helper"
require 'i18n_data/file_data_provider'

describe I18nData::FileDataProvider do
  let(:cache_file) { I18nData::FileDataProvider.send(:cache_file_for,"XX","YY") }

  around do |test|
    `rm -f #{cache_file}`
    test.call
    `rm -f #{cache_file}`
  end

  def read(x,y)
    I18nData::FileDataProvider.codes(x,y)
  end

  it "always produces uppercase locales to avoid case-sensitive madness" do
    cache_file = I18nData::FileDataProvider.send(:cache_file_for,"countries","yy_YY")
    File.basename(cache_file).should == "countries-YY_YY.txt"
  end

  it "always convert hyphen (-) to underscore (_) in locale names" do
    cache_file = I18nData::FileDataProvider.send(:cache_file_for,"countries","yy-YY")
    File.basename(cache_file).should == "countries-YY_YY.txt"
  end

  it "preserves data when writing and then reading" do
    data = {"x"=>"y","z"=>"w"}
    I18nData::FileDataProvider.send(:write_to_file, data, cache_file)
    read("XX","YY").should == data
  end

  it "does not write empty data sets" do
    I18nData::FileDataProvider.send(:write_to_file,{}, cache_file)
    lambda { read("XX","YY") }.should raise_error I18nData::NoTranslationAvailable
  end

  it "reads taiwan correctly" do
    read(:countries, "en")["TW"].should == "Taiwan"
  end

  it "reads as utf-8" do
    read(:countries, "en")["AX"].encoding.should == Encoding::UTF_8
  end
end
