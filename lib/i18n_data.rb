require 'open-uri'
require 'rexml/document'

module I18NData
  ENGLISH_LANGUAGE_CODES =  'http://svn.debian.org/viewsvn/*checkout*/pkg-isocodes/trunk/iso-codes/iso_639/iso_639.xml'
  LANGUAGE_TRANSLATIONS =   'http://svn.debian.org/viewsvn/*checkout*/pkg-isocodes/trunk/iso-codes/iso_639/'

  extend self
  
  def languages(language_code='EN')
    language_code = language_code.upcase
    if language_code == 'EN'
      english_languages
    else
      translated_languages(language_code)
    end
  end

private

  def translated_languages(language_code)
    translated = {}
    english_languages.each do |code,name|
      translation = translate_language(name,language_code)
      translated[code] = translation ? translation : name
    end
    translated
  end

  def english_languages
    return @english_languages if @english_languages
    codes = {}
    english_languages_xml.elements.each('*/iso_639_entry') do |entry|
      name = entry.attributes['name'].to_s.gsub("'","\\'")
      code = entry.attributes['iso_639_1_code'].to_s.upcase
      next if code.empty? or name.empty?
      codes[code]=name
    end
    @english_languages = codes
  end

  def english_languages_xml
    return @english_languages_xml if @english_languages_xml
    xml = open(ENGLISH_LANGUAGE_CODES).read
    @english_languages_xml = REXML::Document.new(xml)
  end

  def translate_language(language,to_language_code)
    translated = language_translations(to_language_code)[language]
    translated.to_s.empty? ? nil : translated
  end

  def language_translations(language_code)
    @language_translations ||= {}
    return @language_translations[language_code] if @language_translations[language_code]
    begin
      data = open(LANGUAGE_TRANSLATIONS+"#{language_code.downcase}.po").readlines
    rescue
      raise NoOnlineTranslationAvaiable.new("language code = #{language_code}")
    end

    names = data.select{|l| l =~ /^msgid/}.map{|line| line.match(/^msgid "(.*?)"/)[1]}
    translations = data.select{|l| l =~ /^msgstr/}.map{|line| line.match(/^msgstr "(.*?)"/)[1]}

    translated = {}
    names.each_with_index do |name,index|
      translated[name]=translations[index]
    end
    
    @language_translations[language_code] = translated
  end
  
  class NoOnlineTranslationAvaiable < Exception
    def to_s
      "NoOnlineTranslationAvaiable -- #{super}"
    end
  end
end

