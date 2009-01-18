Problem
=======
 - Present users coutries/languages in their language
 - Convert a country/language-name to its code

Solution
========
 - A list of 2-letter-code/name pairs for all countries/languages in all languages
 - A tool to convert a coutry/language name into 2-letter-code
 - Write countries/language into a cache-file, and use this file for production applications languages/countries list

Containing
==========
Translations through [debian pkg-isocodes](http://svn.debian.org/wsvn/pkg-isocodes/trunk/iso-codes/)  
185 Language codes (iso 639 - 2 letter)  
in 66 Languages  
246 Country codes (iso 3166 - 2 letter)  
in 85 Languages  

Usage
=====

    sudo gem install grosser-i18n_data
    require 'i18n_data'
    ...
    I18NData.languages        # {"DE"=>"German",...}
    I18NData.languages('DE')  # {"DE"=>"Deutsch",...}
    I18NData.languages('FR')  # {"DE"=>"Allemand",...}
    ...

    I18NData.countries        # {"DE"=>"Germany",...}
    I18NData.countries('DE')  # {"DE"=>"Deutschland",...}
    ...

    #Not yet implemented...
    I18NData.language_code('German')       # DE
    I18NData.language_code('Deutsch')      # DE
    I18NData.language_code('Allemand')     # DE
    ..

    I18NData.country_code('Germany')       # DE
    I18NData.country_code('Deutschland')   # DE
    ..

Performance
===========
 - FileDataProvider: _FAST_ (default) (loading data from cache-files)
 - LiveDataProvider: _SLOW_ (fetching data from svn repos)

TODO
====
 - include other language/country code formats (3-letter codes...) ?
 
Author
======
Michael Grosser  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...  