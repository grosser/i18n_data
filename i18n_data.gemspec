# frozen_string_literal: true
name = "i18n_data"
require "./lib/#{name}/version"

Gem::Specification.new name, I18nData::VERSION do |s|
  s.summary = "country/language names and 2-letter-code pairs, in 85 languages"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files lib cache `.split("\n")
  s.license = "MIT"
  s.required_ruby_version = '>= 3.0.0' # keep in sync with rubocop.yml and actions.yml
  s.add_dependency 'simple_po_parser', '~> 1.1'
end
