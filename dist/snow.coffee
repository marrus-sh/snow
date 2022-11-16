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
Object.defineProperty window, "Snow",
    value : Object.freeze
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


#  These are our location binary flags:
FROM_PUBLIC    = 0b000000001
FROM_USER      = 0b000000010
FROM_TAG       = 0b000000100
ONLY_LOCAL     = 0b000001000
ONLY_MEDIA     = 0b000010000
WITH_MENTIONS  = 0b000100000
SHOW_TIMELINE  = 0b001000000
SHOW_USER      = 0b010000000
SHOW_POST      = 0b100000000

#  These constants give us our locations:
NOTFOUND = 0
HOME     = SHOW_TIMELINE
LOCAL    = SHOW_TIMELINE | FROM_PUBLIC | ONLY_LOCAL
GLOBAL   = SHOW_TIMELINE | FROM_PUBLIC
TAG      = SHOW_TIMELINE | FROM_TAG
USER     = SHOW_TIMELINE | FROM_USER   | SHOW_USER
POST     = SHOW_USER     | SHOW_POST


#  This sets up our Locales object
Locales = {}

Locales.en =  #  English localization

    #  Authorization:
    "auth.placeholder"  : "example.com"
    "auth.query"        : "What's your instance?"
    "auth.username"     : "username"
    
    #  Config defaults:
    "config.title"      : "Snow Web Client"
        
    #  Errors:
    "error.laboratory"  : "This version of Laboratory is not supported."
        
    #  Locations (used in URLs):
    "location.all"      : "all"
    "location.global"   : "global"
    "location.local"    : "local"
    "location.media"    : "media"
    "location.tag"      : "tag"
    "location.user"     : "user"
        
    #  Various site links:
    "link.home"         : "Home"
    "link.local"        : "Local"
    "link.global"       : "Global"
        
    #  Not found:
    "notfound.notfound" : "Not found!"
    "notfound.message"  : "The page you were looking for does not exist."

init = ->  #  This initializes Snow

    #  Here we load our configuration information from the "snow-config" element, if available:
    if (elt = document.getElementById "snow-config") and
        do elt.tagName.toUpperCase is "SCRIPT" and
        (elt.type is "application/json" or elt.type is "text/plain")
            config = JSON.parse elt.text

    #  If an INITIAL_STATE is provided, we use that to fill in any blanks:
    INITIAL_STATE = {meta: {}} unless INITIAL_STATE?.meta?
    initial =
        title: INITIAL_STATE.meta.title
        basename:
            if INITIAL_STATE.meta.router_basename? then INITIAL_STATE.meta.router_basename
            else "/web"
        locale: INITIAL_STATE.meta.locale
        root: INITIAL_STATE.meta.react_root
        defaultPrivacy: INITIAL_STATE.composer?.default_privacy || "unlisted"
        accessToken: INITIAL_STATE.meta.accessToken
        origin: INITIAL_STATE.meta.origin || "/"
    config[prop] = initial[prop] for prop in [
        "title", "basename", "locale", "root", "defaultPrivacy", "accessToken", "origin"
    ] when not config[prop]?
        
    #  This selects our root element:
    config.root = switch
        when config.root and (elt = document.getElementById String config.root) then elt
        when (elt = document.getElementById "frontend") then elt
        when (elt = (document.getElementsByClassName "app-body").item 0) then elt
        else document.body
    config.root.classList.add "🌨"

    #  We set our display options on the document element using `data-snow-display`:
    config.display ?= []
    config.display = [config.display] unless config.display instanceof Array
    config.root.setAttribute "data-snow-display", config.display.join " "

    #  This loads our `config.locales` into our `Locales` object:
    for locale, data of config.locales
        Locales[locale] = {} unless Locales[locale] instanceof Object
        Locales[locale][message] = value for message, value of data
        
    #  This sets our current locale, defaulting to `"en"`:
    config.locale = "en" unless config.locale?
    config.root.setAttribute "lang", config.locale
        
    #  This sets our title:
    config.title ?= Ε "config.title"
    document.title = config.title

    run = ->  #  Starts the engine.
    
        #  Snow requires Laboratory 0.5 or later:
        unless Laboratory.ℹ is "https://github.com/marrus-sh/laboratory" and Laboratory.Nº >= 5
            throw new TypeError Ε "error.laboratory"
            
        #  Here we set up our Laboratory shortcuts:
        Lab = Laboratory
        LAp = Laboratory.Application
        LAt = Laboratory.Attachment
        LAu = Laboratory.Authorization
        LCl = Laboratory.Client
        LEn = Laboratory.Enumeral
        LFa = Laboratory.Failure
        LPo = Laboratory.Post
        LPr = Laboratory.Profile
        LRe = Laboratory.Request
        LRo = Laboratory.Rolodex
        LTi = Laboratory.Timeline
            
        #  If we have an access token, we need to pass it to Laboratory:
        if config.accessToken then do (
            new LAu.Requested
                accessToken: config.accessToken
                origin: config.origin
                scope: LAu.Scope.READWRITEFOLLOW
        ).start
        
        #  Otherwise, we need to request one:
        else do authorize
        
        #  This starts the frontend once we have auth:
        callback = ->
            do go
            document.removeEventListener "LaboratoryAuthorizationReceived", callback
        document.addEventListener "LaboratoryAuthorizationReceived", callback

    #  We can only `run()` if Laboratory has finished initializing:
    if Laboratory?.ready then do run
    else document.addEventListener "LaboratoryInitializationReady", run

window.addEventListener "load", init

#  All of our helper functions are capital greek letters.
#  (Watch out, because some of them look latin!)
#  This allows us to concisely call them in our scripts without worrying about name collisions.

#  The functions may be summarized as follows:
#  Σ – Create new element with the provided children
#  σ – Create new element with the provided innerHTML
#  Τ – Put contents into element (overwrites existing contents)
#  τ – Put contents into element (without overwriting)
#  Ε – Get the proper localization for the given key

#  Σ looks like an E but it's actually the uppercase form of σ, as in στοιχεῖον:
Σ = (name, attributes, children...) ->
    elt = document.createElement String name
    if attributes is Object attributes
        for attribute, value of attributes when value? and value isnt off
            elt.setAttribute attribute, if value is on then "" else value
    for child in children when child?
        elt.appendChild (
            if child instanceof Node then child else document.createTextNode String child
        )
    return elt
    
#  The lowercase version σ uses innerHTML instead:
σ = (name, attributes, innerHTML) ->
    elt = document.createElement String name
    if attributes is Object attributes
        for attribute, value of attributes when value? and value isnt off
            elt.setAttribute attribute, if value is on then "" else value
    elt.innerHTML = innerHTML
    return elt
    
#  This is a capital τ (as in τίθημι), not a latin T:
Τ = (element, nodes...) ->
    return unless element instanceof Element
    element.textContent = ""
    for node in nodes when node?
        element.appendChild (
            if node instanceof Node then node else document.createTextNode String node
        )
    return element
    
#  The lowercase version τ doesn't erase its element's original contents:
τ = (element, nodes...) ->
    return unless element instanceof Element
    for node in nodes when node?
        element.insertBefore (
            if node instanceof Node then node else document.createTextNode String node
        ), if this instanceof Node then this else null
    return element
    
#  This is a capital ε (as in ἑρμηνεύω), not a latin E:
Ε = (key, locale) ->
    key = String key
    locale ?= config.locale or "en"
    locale = do locale.toLowerCase
    localized[locale] = {} unless localized[locale]?
    return localized[locale][key] if localized[locale][key]?
    result = switch
        when Locales[locale]? and Locales[locale][key]? then Locales[locale][key]
        when locale is "en" then key
        else Ε key, if "-" in locale then locale.substr 0, locale.indexOf "-" else "en"
    return localized[locale][key] = result


authorize = ->  #  Creates the authorization window, prompting users for their instance

    handleEvent = (event) ->  #  Requests authorization from the provided instance if possible
        if (
            event.type is "keypress" and event.target is input and (
                event.key is "Enter" or event.code is "Enter" or event.keyCode is 0x0D
            ) or event.type is "click" and event.target is button
        ) and input.value.length and input.validity.valid
            (
                new LAu.Request
                    name: config.title
                    origin: "https://" + input.value
                    redirect: config.basename
                    scope: LAu.Scope.READWRITEFOLLOW
            ).start window.open "about:blank", "SnowOAuth"
            input.value = ""
    
    #  This fills the root element with our authorization window:
    Τ config.root,
        Σ "DIV", {id: "🌨🔓"},
            Σ "H1", undefined, Ε "auth.query"
            Σ "P", undefined,
                (Ε "auth.username") + "@"
                input = Σ "INPUT",
                    pattern: "[0-9A-Za-z\\-\\.]+(\\:[0-9]{1,4})?"
                    placeholder: Ε "auth.placeholder"
                button = Σ "BUTTON", undefined, "GO!"
    input.addEventListener "keypress", handleEvent
    button.addEventListener "click", handleEvent

go = ->  #  Actually starts frontend rendering

    Τ config.root,
        Σ "A", {
            href: "#!/"
            target: "_self"
        }, Σ "HEADER", {id: "🌨▔"}, Σ "H1", undefined, config.title
        state.window = Σ "DIV", {id: "🌨🗔"}
        state.composer = Σ "DIV", {id: "🌨📝"}
    
    location.hash = "#!/"
    do locate
    window.addEventListener "hashchange", locate
    

locate = ->  #  Handles the hash and renders the frontend accordingly

    #  This ends any currently-open requests:
    do fn for fn in cleanup when typeof fn is "function"
    cleanup = []

    #  Here we get our path:
    hash = "#!/" unless ((hash = location.hash).substr 0, 3) is "#!/"
    path = (hash.substr 3).split "/"
    base = path[0]
    
    #  This gets our location (and other info) from our path:
    state.location = switch base
        when "", undefined then HOME
        when Ε "location.global" then GLOBAL
        when Ε "location.local" then LOCAL
        when Ε "location.tag"
            state.query = +path[1]
            TAG
        when Ε "location.user"
            state.query = +path[1]
            switch path[2]
                when Ε "location.media" then USER | ONLY_MEDIA
                when Ε "location.all" then USER | WITH_MENTIONS
                when "", undefined then USER
                else
                    if not isNaN path[2]
                        state.status = +path[2]
                        POST
                    else NOTFOUND
        else NOTFOUND
    
    #  This runs the appropriate rendering functions:
    if state.location is NOTFOUND then do notfound
    else
        if state.location & SHOW_USER then do user else do nobody
        if state.location & SHOW_TIMELINE then do timeline
        if state.location & SHOW_POST then do post
    

notfound = ->  #  Renders the "Not Found" page

    state.timeline = null
    Τ state.window,
        Σ "DIV", {id: "🌨🛇"},
            Σ "H2", null, Ε "notfound.notfound"
            Σ "P", null, Ε "notfound.message"

user = ->  #  Renders a user page

    header = undefined    
    
    handleRequest = (response) ->
        return unless response instanceof LPr
        Τ header,
            Σ "A", {
                href: response.header
                target: "_blank"
            }, Σ "IMG",
                alt: "Header image for " + (response.displayName or response.account)
                src: response.header
            Σ "A", {
                href: response.href
                title: response.displayName
                target: "_blank"
            },
                Σ "IMG",
                    alt: (response.displayName or response.account) + "'s avatar"
                    src: response.avatar
                Σ "H2", undefined, response.displayName
                Σ "CODE", undefined, response.account
            σ "P", undefined, response.bio

    Τ state.window,
        header = Σ "HEADER"
        state.timeline = Σ "DIV", {id: "🌨📜"}

    request = new LPr.Request
        id: state.query
    request.assign handleRequest
    do request.start
    cleanup.push request.stop

nobody = ->  #  Renders a non-user page

    AorB = (useB, object, contents) ->
        if useB then Σ "B", undefined, contents else Σ "A", object, contents

    Τ state.window,
        Σ "NAV", {id: "snow-navbar"},
            AorB state.location & SHOW_TIMELINE and not (state.location & FROM_PUBLIC), {
                href: "#!/"
                target: "_self"
            }, Ε "link.home"
            AorB state.location & SHOW_TIMELINE and state.location & ONLY_LOCAL, {
                href: "#!/" + Ε "location.local"
                target: "_self"
            }, Ε "link.local"
            AorB state.location & SHOW_TIMELINE and state.location & FROM_PUBLIC and
                not (state.location & ONLY_LOCAL), {
                    href: "#!/" + Ε "location.global"
                    target: "_self"
                }, Ε "link.global"
        state.timeline = Σ "DIV", {id: "🌨📜"}

timeline = ->  #  Renders a timeline

    return unless (tl = state.timeline) instanceof Element
    timeout = null

    update = (req) ->
        do req.stop
        req.remove handleRequest
        req = do req.prev
        req.assign handleRequest
        do req.start
        
    renderStatus = (status) ->
        scrollBottom = tl.scrollHeight - tl.scrollTop
        Σ "ARTICLE", undefined,
            Σ "HEADER", undefined,
                Σ "A", {
                    href   : "#!/" + (Ε "location.user") + "/" + status.author.id
                    target : "_self"
                }, Σ "IMG",
                    alt: (status.author.displayName or status.author.account) + "'s avatar"
                    src: status.author.avatar
                Σ "A", {
                    href   : "#!/" + (Ε "location.user") + "/" + status.author.id
                    target : "_self"
                },
                    Σ "B", undefined, status.author.displayName
                    Σ "CODE", undefined, status.author.localAccount
            Σ "DIV", {
                class               : "🌨📰"
                "data-snow-message" : if status.message then status.message
            },
                if status.mediaAttachments?.length then Σ "A", {
                    href   : 
                        "#!/" + [
                            (Ε "location.user"), status.author.id, status.id
                        ].join "/"
                    target : "_self"
                }, Σ "FIGURE", {
                    "data-snow-attachment-count" : status.mediaAttachments.length
                    "data-snow-nsfw"             : !!status.isNSFW
                }, (
                    for attachment in status.mediaAttachments then do ->
                        media =
                            if attachment.type & LAt.Type.VIDEO then Σ "VIDEO",
                                controls : attachment.type isnt LAt.Type.GIFV
                                loop     : attachment.type is LAt.Type.GIFV
                                muted    : attachment.type is LAt.Type.GIFV
                                poster   : attachment.preview
                                src      : attachment.href
                            else Σ "IMG", {src : attachment.href}
                        media.addEventListener "load", ->
                            tl.scrollTop = tl.scrollHeight - scrollBottom
                        if attachment.type is LAt.Type.GIFV
                            media.addEventListener "mouseover", media.play
                            media.addEventListener "mouseleave", media.pause
                        return media
                )...
                σ "SECTION", undefined, status.content
            Σ "FOOTER", undefined,
                Σ "A", {
                    href   : "#!/" + [
                        (Ε "location.user"), status.author.id, status.id
                    ].join "/"
                    target : "_self"
                }, status.datetime
                (
                    if status.application then [
                        " • "
                        if status.application.href then Σ "A", {
                            href   : status.application.href
                            target : "_blank"
                        }, status.application.name else status.application.name
                    ] else []
                )...

    handleRequest = (response) ->
        return unless response instanceof LTi
        if tl.scrollTop is tl.scrollHeight - tl.clientHeight then doScroll = yes
        if response.length
            τ tl, (
                for i in [response.posts.length - 1 .. 0] then renderStatus response.posts[i]
            )...
            if doScroll then tl.scrollTop = tl.scrollHeight - tl.clientHeight
            update this
        else timeout = window.setTimeout @start, 3000

    handleBackRequest = (response) ->
        return unless response instanceof LTi
        scrollBottom = tl.scrollHeight - tl.scrollTop
        if response.length then τ.call tl.firstElementChild, tl, (
            for status in response.posts then renderStatus status
        )...
        tl.scrollTop = tl.scrollHeight - scrollBottom  

    request = new LTi.Request
        type: switch
            when state.location & FROM_PUBLIC then LTi.Type.PUBLIC
            when state.location & FROM_TAG then LTi.Type.HASHTAG
            when state.location & FROM_USER then LTi.Type.ACCOUNT
            else LTi.Type.HOME
        query: if state.location & FROM_USER or state.location & FROM_TAG then state.query
        isLocal: state.location & ONLY_LOCAL
        #  Media and reply bools will go here eventually tho
    request.assign handleRequest
    do request.start
    
    backRequest = undefined
    
    tl.addEventListener "scroll", -> if tl.scrollTop < 32 and request.response
        return if backRequest and not backRequest.response
        if backRequest
            do backRequest.stop
            backRequest.remove handleBackRequest
        backRequest = do (backRequest or request).next
        backRequest.assign handleBackRequest
        do backRequest.start

    cleanup.push ->
        window.clearTimeout timeout if timeout?
        do request.stop
        do backRequest.stop if backRequest


post = ->  #  Renders a post