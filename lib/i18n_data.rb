require 'active_support'

module I18nData
  VERSION = File.read( File.join(File.dirname(__FILE__), '..', 'VERSION') ).strip
  
  extend self
  
  def languages(language_code='EN')
    data_provider.codes(:languages, language_code.to_s.upcase)
  end

  def countries(language_code='EN')
    data_provider.codes(:countries, language_code.to_s.upcase)
  end

  def country_code(name)
    recognise_code(:countries, name)
  end

  def language_code(name)
    recognise_code(:languages, name)
  end

  def data_provider
    if @data_provider
      @data_provider
    else
      require 'i18n_data/file_data_provider'
      FileDataProvider
    end
  end

  def data_provider=(provider)
    @data_provider = provider
  end

  private

  def recognise_code(type, search)
    search = search.strip
    languages.keys.each do |code|
      begin
        send(type, code).each do |code, name|
          return code if search == name
        end
      rescue NoTranslationAvailable
      end
    end
    nil
  end
  
  class NoTranslationAvailable < Exception
    def to_s
      "NoTranslationAvailable -- #{super}"
    end
  end
end