require 'open-uri'
require 'cgi'
require 'rexml/document'

module I18NData
  ENGLISH_LANGUAGE_CODES = 'http://svn.debian.org/wsvn/pkg-isocodes/trunk/iso-codes/iso_639/iso_639.xml?op=file'


  extend self
  
  def languages(language='EN')
    language.upcase!
    if language == 'EN'
      english_languages
    else
      {'DE'=>'Deutsch'}
    end
  end

private

  def english_languages
    codes = {}
    english_languages_xml.elements.each('*/iso_639_entry') do |entry|
      name = entry.attributes['name'].to_s.gsub("'","\\'")
      code = entry.attributes['iso_639_1_code'].to_s.upcase
      codes[code]=name
    end
    codes
  end

  #TODO get file direct from svn...
  def english_languages_xml
    return @english_languages_xml if @english_languages_xml
    page = open(ENGLISH_LANGUAGE_CODES).read
    xml = CGI::unescapeHTML(/<pre>(.+)<\/pre>/im.match(page)[1].gsub('&nbsp;',''))
    @english_languages_xml = REXML::Document.new(xml)
  end
end