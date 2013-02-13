 - Present users coutries/languages in their language
 - Convert a country/language-name to its 2-letter-code
 - List of 2-letter-code/name pairs for all countries/languages in all languages

###Translations
Through [pkg-isocodes](http://git.debian.org/?p=iso-codes/iso-codes.git):

 - 185 Language codes (iso 639 - 2 letter) in 68 Languages
 - 246 Country codes (iso 3166 - 2 letter) in 86 Languages
 - contry specific codes e.g. zh_TW are also available, have a look at the isocodes website for all options

Install
=======

    gem install i18n_data

Usage
=====

    require 'i18n_data'
    ...
    I18nData.languages        # {"DE"=>"German",...}
    I18nData.languages('DE')  # {"DE"=>"Deutsch",...}
    I18nData.languages('FR')  # {"DE"=>"Allemand",...}
    ...

    I18nData.countries        # {"DE"=>"Germany",...}
    I18nData.countries('DE')  # {"DE"=>"Deutschland",...}
    ...

    I18nData.language_code('German')       # DE
    I18nData.language_code('Deutsch')      # DE
    I18nData.language_code('Allemand')     # DE
    ..

    I18nData.country_code('Germany')       # DE
    I18nData.country_code('Deutschland')   # DE
    ..

Data Providers
==============
 - FileDataProvider: _FAST_ (default) (loading data from cache-files)
 - LiveDataProvider: _SLOW_ (fetching up-to-date data from svn repos)

Development
=======
 - update FileDataProvider caches after each code-change to make changes available to users `rake write_cache_for_file_data_provider`
 - FileDataProvider tests might fail if caches are not updates

TODO
====
 - include other language/country code formats (3-letter codes...) ?
 - parse list of files on isocodes for write_cache instead of hardcoding country-specific ones

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/i18n_data.png)](https://travis-ci.org/grosser/i18n_data)

