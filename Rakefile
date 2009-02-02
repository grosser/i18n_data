$LOAD_PATH << File.join(File.dirname(__FILE__),"..","lib")
require 'lib/i18n_data'#TODO should not be necessary but is :/
require 'yaml'

desc "Run all specs in spec directory"
task :test do |t|
  options = "--colour --format progress --loadby --reverse"
  files = FileList['spec/**/*_spec.rb']
  system("spec #{options} #{files}")
end

desc "write all languages to output"
task :all_languages do
  I18nData.languages.keys.each do |lc|
    `rake languages LANGUAGE=#{lc}`
  end
end

desc "write languages to output/languages_{language}"
task :languages do
  raise unless language = ENV['LANGUAGE']
  `mkdir output -p`
  data = I18nData.languages(language.upcase)
  File.open("output/languages_#{language.downcase}.yml",'w') {|f|f.puts data.to_yaml}
end

desc "write all countries to output"
task :all_countries do
  I18nData.languages.keys.each do |lc|
    `rake countries LANGUAGE=#{lc}`
  end
end

desc "write countries to output/countries_{language}"
task :countries do
  raise unless language = ENV['LANGUAGE']
  `mkdir output -p`
  data = I18nData.countries(language.upcase)
  File.open("output/countries_#{language.downcase}.yml",'w') {|f|f.puts data.to_yaml}
end

desc "write example output, just to show off :D"
task :example_output do
  `mkdir example_output -p`
  
  #all names for germany, france, united kingdom and unites states
  ['DE','FR','GB','US'].each do |cc|
    names = I18nData.languages.keys.map do |lc|
      begin
        [I18nData.countries(lc)[cc], I18nData.languages[lc]]
      rescue I18nData::NoOnlineTranslationAvaiable
        nil
      end
    end
    File.open("example_output/all_names_for_#{cc}.txt",'w') {|f|
      f.puts names.reject(&:nil?).map{|x|x*" ---- "} * "\n"
    }
  end
end

desc "write cache for I18nData::FileDataProvider"
task :write_cache_for_file_data_provider do
  require 'i18n_data/file_data_provider'
  require 'i18n_data/live_data_provider'
  I18nData::FileDataProvider.write_cache(I18nData::LiveDataProvider)
end

require 'echoe'

Echoe.new('i18n_data', '0.2.0') do |p|
  p.description    = "country/language names and 2-letter-code pairs, in 85 languages, for country/language "
  p.url            = "http://github.com/grosser/i18n_data"
  p.author         = "Michael Grosser"
  p.email          = "grosser.michael@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*", "nbproject/*", "nbproject/*/*", "output/*", "example_output/*"]
  p.dependencies   = ['rexml','open-uri'] #requires activesupport, but crashes on require when activesupport is already loaded WTF!
  p.development_dependencies = ['echoe','spec','mocha','activesupport']
end

task :update_gemspec => [:manifest, :build_gemspec]