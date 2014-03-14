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
        Hash[send("english_#{type}").map do |code, name|
          [code, translate(type, name, language_code) || name]
        end]
      end
    end

    def translations(type, language_code)
      @translations ||= {}
      @translations["#{type}_#{language_code}"] ||= begin
        code = language_code.split("_")
        code[0].downcase!
        code = code.join("_")

        begin
          url = TRANSLATIONS[type]+"#{code}.po"
          data = get(url)
        rescue => e
          case e.to_s
          when /\A404 /
            raise NoTranslationAvailable, "for #{type} and language code = #{code} (#{$!})"
          when /\A502 /
            raise AccessDenied, "for #{type} and language code = #{code} (#{$!})"
          else
            raise Unknown, "#{e.to_s} for #{type} and language code = #{code} (#{$!})"
          end
        end

        data = data.force_encoding('utf-8') if data.respond_to?(:force_encoding) # 1.9
        data = data.split("\n")
        po_to_hash data
      end
    end

    def english_languages
      @english_languages ||= begin
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

      Hash[names.each_with_index.map do |name,index|
        [name, translations[index]]
      end]
    end

    def get(url)
      $stderr.puts "GET #{url}" if $DEBUG
      @@cache ||= {}
      return @@cache[url] if @@cache.include? url
      @@cache[url] = open(url).read
    end

    def xml(type)
      xml = get(XML_CODES[type])
      REXML::Document.new(xml)
    rescue => e
      case e.to_s
      when /\A502 /
        raise AccessDenied, "for index of #{type} (#{$!})"
      else
        raise Unknown, "#{e.to_s} for index of #{type} (#{$!})"
      end
    end
  end
end
