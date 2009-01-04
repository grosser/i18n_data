require 'init'

desc 'Default: run spec.'
task :default => :spec

desc "Run all specs in spec directory"
task :spec do |t|
  options = "--colour --format progress --loadby --reverse"
  files = FileList['spec/**/*_spec.rb']
  system("spec #{options} #{files}")
end

desc "write languages to output/languages_{language}"
task :languages do
  raise unless language = ENV['LANGUAGE']
  data = I18NData.languages(language.upcase)
  File.open("output/languages_#{language.downcase}.yml",'w') {|f|f.puts data}
end

desc "write countries to output/countries_{language}"
task :countries do
  raise unless language = ENV['LANGUAGE']
  data = I18NData.countries(language.upcase)
  File.open("output/countries_#{language.downcase}.yml",'w') {|f|f.puts data}
end