Problem
=======
 - Presend users a coutry/language choise in their language
 - Convert a Coutry/Language-name to its code

Solution
========
 - A list of code/name pairs for all countries/languages in all languages
 - A tool to convert a coutry/language name into code

Containing
==========
185 Language codes (iso 3166 - 2 letter)
??? Country codes (iso 639 - 2 letter)
in ?? Languages


Usage
=====

    I18NData.languages        # {"DE"=>"German",...}
    I18NData.languages('DE')  # {"DE"=>"Deutsch",...}
    I18NData.languages('FR')  # {"DE"=>"Allemand",...}
    ...

    I18NData.countries        # {"DE"=>"Germany",...}
    I18NData.countries('DE')  # {"DE"=>"Deutschland",...}
    ...

    I18NData.language_code('German')       # DE
    I18NData.language_code('Deutsch')      # DE
    I18NData.language_code('Allemand')     # DE
    ..

    I18NData.country_code('Germany')       # DE
    I18NData.country_code('Deutschland')   # DE
    ..

Author
======
Michael Grosser  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...  