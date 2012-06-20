require 'open-uri'
require 'rexml/document'

module I18nData
  # fetches data online from debian svn
  module LiveDataProvider
    extend self

    ROOT = "http://git.debian.org/?p=iso-codes/iso-codes.git;a=blob_plain;f="

    XML_CODES = {
      :countries => ROOT + 'iso_3166/iso_3166.xml',
      :languages => ROOT + 'iso_639/iso_639.xml'
    }
    TRANSLATIONS = {
      :countries => ROOT + 'iso_3166/',
      :languages => ROOT + 'iso_639/'
    }

    def codes(type, language_code)
      language_code = language_code.upcase
      if language_code == 'EN'
        send("english_#{type}")
      else
        translated(type, language_code)
      end
    end

  private

    def translate(type, language, to_language_code)
      translated = translations(type, to_language_code)[language]
      translated.to_s.empty? ? nil : translated
    end

    def translated(type, language_code)
      @translated ||= {}
      @translated["#{type}_#{language_code}"] ||= begin
        # TODO inject or Hash[]
        translations = {}
        send("english_#{type}").each do |code,name|
          translation = translate(type, name, language_code)
          translations[code] = translation || name
        end
        translations
      end
    end

    def translations(type, language_code)
      @translations ||= {}
      @translations["#{type}_#{language_code}"] ||= begin
        begin
          url = TRANSLATIONS[type]+"#{language_code.downcase}.po"
          data = open(url).read
        rescue
          raise NoTranslationAvailable, "for #{type} and language code = #{language_code} (#{$!})"
        end

        data = data.force_encoding('utf-8') if data.respond_to?(:force_encoding) # 1.9
        data = data.split("\n")
        po_to_hash data
      end
    end

    def english_languages
      @english_languages ||= begin
        # TODO use inject or Hash[]
        codes = {}
        xml(:languages).elements.each('*/iso_639_entry') do |entry|
          name = entry.attributes['name'].to_s.gsub("'", "\\'")
          code = entry.attributes['iso_639_1_code'].to_s.upcase
          next if code.empty? or name.empty?
          codes[code] = name
        end
        codes
      end
    end

    def english_countries
      @english_countries ||= begin
        # TODO use inject or Hash[]
        codes = {}
        xml(:countries).elements.each('*/iso_3166_entry') do |entry|
          name = entry.attributes['name'].to_s.gsub("'", "\\'")
          code = entry.attributes['alpha_2_code'].to_s.upcase
          codes[code] = name
        end
        codes
      end
    end

    def po_to_hash(data)
      names = data.select{|l| l =~ /^msgid/ }.map{|line| line.match(/^msgid "(.*?)"/)[1] }
      translations = data.select{|l| l =~ /^msgstr/ }.map{|line| line.match(/^msgstr "(.*?)"/)[1] }

      translated = {}
      names.each_with_index do |name,index|
        translated[name]=translations[index]
      end
      translated
    end

    def xml(type)
      xml = open(XML_CODES[type]).read
      REXML::Document.new(xml)
    end
  end
end
