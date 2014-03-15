name = "i18n_data"
require "./lib/#{name}/version"

Gem::Specification.new name, I18nData::VERSION do |s|
  s.summary = "country/language names and 2-letter-code pairs, in 85 languages"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files lib cache `.split("\n")
  s.license = "MIT"
  cert = File.expand_path("~/.ssh/gem-private-key-grosser.pem")
  if File.exist?(cert)
    s.signing_key = cert
    s.cert_chain = ["gem-public_cert.pem"]
  end
end
