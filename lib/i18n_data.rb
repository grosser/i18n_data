require 'i18n_data/version'

module I18nData

  class BaseException < StandardError
    def to_s
      "#{self.class} -- #{super}"
    end
  end

  class NoTranslationAvailable < BaseException; end
  class AccessDenied < BaseException; end
  class Unknown < BaseException; end

  class << self
    def languages(language_code='EN')
      fetch :languages, language_code do
        data_provider.codes(:languages, normal_to_region_code(language_code.to_s.upcase))
      end
    end

    def countries(language_code='EN')
      fetch :countries, language_code do
        data_provider.codes(:countries, normal_to_region_code(language_code.to_s.upcase))
      end
    end

    def country_code(name)
      recognise_code(:countries, name)
    end

    def language_code(name)
      recognise_code(:languages, name)
    end

    def data_provider
      @data_provider ||= (
        require 'i18n_data/file_data_provider'
        FileDataProvider
      )
    end

    def data_provider=(provider)
      @cache = nil
      @data_provider = provider
    end

    private

    def fetch(type, language_code)
      @cache ||= Hash.new { |h, k| h[k] = {} }
      @cache[type].fetch(language_code) { @cache[type][language_code] = yield }
    end

    # hardcode languages that do not have a default type
    # e.g. zh does not exist, but zh_CN does
    def normal_to_region_code(normal)
      {
        "ZH" => "zh_CN",
        "BN" => "bn_IN",
      }[normal] || normal
    end

    def recognise_code(type, search)
      search = search.strip

      # common languages first <-> faster in majority of cases
      common_language_codes = ['EN','ES','FR','DE','ZH']
      language_codes = common_language_codes.concat (available_language_codes - common_language_codes)

      language_codes.detect do |language_code|
        begin
          send(type, language_code).detect do |code, name|
            # support "Dutch" and "Dutch; Flemish", checks for inclusion first -> faster
            return code if (name.include?(search) && name.split(';').each(&:strip!).include?(search))
          end
        rescue NoTranslationAvailable
        end
      end
    end

    # NOTE: this is not perfect since the used provider might have more or less languages available
    # but it's better than just using the available english language codes
    def available_language_codes
      @available_languges ||= begin
        files = Dir[File.expand_path("../../cache/file_data_provider/languages-*", __FILE__)]
        files.map! { |f| f[/languages-(.*)\./, 1] }
      end
    end
  end
end
