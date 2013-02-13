$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
name = "i18n_data"
require "#{name}/version"

Gem::Specification.new name, I18nData::VERSION do |s|
  s.summary = "country/language names and 2-letter-code pairs, in 85 languages"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files`.split("\n")
  s.license = "MIT"
  s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem")
  s.cert_chain = ["gem-public_cert.pem"]
end
