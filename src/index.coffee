###

    ................. SNOW ..................

     A client-side frontend for Mastodon, a
    free & open-source social network server.
               - - by Kibigo! - -

        Licensed under the MIT License.
           Source code available at:
       https://github.com/marrus-sh/snow

                Version 0.1.0

###

"use strict;"

#  The `window.Snow` object can be used by plugins to check versioning/compatibility:
Object.defineProperty window , "Snow" ,
    value      : Object.freeze
        "ℹ"  : "https://github.com/marrus-sh/snow"
        "Nº" : 1.0
    enumerable : yes
    
#  The `config` object will hold our frontend configuration:
config = {}

#  The `state` object will store various variables we will need while running:
state = {}

#  The `localized` object will cache our localizations:
localized = {}

#  The `cleanup` function contains cleanup functions for memory deallocation:
cleanup = []

#  These are our Laboratory shortcut variables:
Lab = LAp = LAt = LAu = LCl = LEn = LFa = LPo = LPr = LRe = LRo = LTi = undefined
