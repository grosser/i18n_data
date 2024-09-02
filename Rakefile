# frozen_string_literal: true
require 'bundler/setup'
require 'bundler/gem_tasks'
require 'bump/tasks'
require 'yaml'

$LOAD_PATH << "lib"
require 'i18n_data'

task default: [:spec, :rubocop]

desc "Run tests"
task :spec do
  sh "rspec --warnings spec/"
end

desc "Rubocop"
task :rubocop do
  sh "rubocop --parallel"
end

desc "write all languages to output"
task :all_languages do
  I18nData.languages.each_key do |lc|
    sh "rake languages LANGUAGE=#{lc}"
  end
end

desc "write languages to output/languages_{LANGUAGE}"
task :languages do
  language = ENV.fetch('LANGUAGE')
  sh "mkdir -p output"
  data = I18nData.languages(language.upcase)
  File.write "output/languages_#{language.downcase}.yml", data.to_yaml
end

desc "write all countries to output to debug"
task :all_countries do
  I18nData.languages.each_key do |lc|
    sh "rake countries LANGUAGE=#{lc}"
  end
end

desc "write countries to output/countries_{LANGUAGE} to debug"
task :countries do
  language = ENV.fetch('LANGUAGE')
  sh "mkdir -p output"
  data = I18nData.countries(language.upcase)
  File.open("output/countries_#{language.downcase}.yml", 'w') { |f| f.puts data.to_yaml }
end

desc "write example output, just to show off :D"
task :example_output do
  `mkdir -p example_output`

  # all names for germany, france, united kingdom and unites states
  ['DE', 'FR', 'GB', 'US'].each do |cc|
    names = I18nData.languages.keys.map do |lc|
      [I18nData.countries(lc)[cc], I18nData.languages[lc]]
    rescue I18nData::NoTranslationAvailable
      nil
    end
    File.open("example_output/all_names_for_#{cc}.txt", 'w') do |f|
      f.puts names.compact.map { |x| x * " ---- " } * "\n"
    end
  end
end

desc "show stats"
task :stats do
  dir = "cache/file_data_provider"
  [:languages, :countries].each do |type|
    files = FileList["#{dir}/#{type}*"]
    lines = File.readlines(files.first).reject(&:empty?)
    puts "#{lines.size} #{type} in #{files.size} languages"
  end
end

desc "write cache for I18nData::FileDataProvider"
task :write_cache_for_file_data_provider do
  require 'i18n_data/file_data_provider'
  require 'i18n_data/live_data_provider'
  sh "rm -rf cache/file_data_provider" # clean everything so old stuff goes away
  I18nData::LiveDataProvider.clear_cache
  I18nData::FileDataProvider.write_cache(I18nData::LiveDataProvider)
  sh "git", "diff", "HEAD", "--exit-code"
end
