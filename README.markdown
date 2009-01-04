Problem
=======
 - Present users coutries/languages in their language
 - Convert a country/language-name to its code

Solution
========
 - A list of 2-letter-code/name pairs for all countries/languages in all languages
 - A tool to convert a coutry/language name into 2-letter-code

Containing
==========
Translations through [debian pkg-isocodes](http://svn.debian.org/wsvn/pkg-isocodes/trunk/iso-codes/)  
185 Language codes (iso 3166 - 2 letter)  
in 66 Languages  
246 Country codes (iso 639 - 2 letter)  
in 85 Languages  

Usage
=====

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
This is *SLOW!*  
I am fetching the codes/translations from the svn repo.  
It is indended to write `languages_xx.yml / countries_xx.yml`  
to use in your applications (e.g. Rails...).

When i find the time to get it working through pkg-isocodes  
(or though the local installation, system independent)  
it could be faster, but it will still be slow,  
since one country-lists would need 246 gettext-requests.

Author
======
Michael Grosser  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...  