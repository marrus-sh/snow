init = ->  #  This initializes Snow

    #  Here we load our configuration information from the "snow-config" element, if available:
    if (elt = document.getElementById "snow-config") and
        do elt.tagName.toUpperCase is "SCRIPT" and
        (elt.type is "application/json" or elt.type is "text/plain")
            config = JSON.parse elt.text

    #  If an INITIAL_STATE is provided, we use that to fill in any blanks:
    INITIAL_STATE = {meta : {}} unless INITIAL_STATE?.meta?
    initial =
        title          : INITIAL_STATE.meta.title
        basename       :
            if INITIAL_STATE.meta.router_basename? then INITIAL_STATE.meta.router_basename
            else "/web"
        locale         : INITIAL_STATE.meta.locale
        root           : INITIAL_STATE.meta.react_root
        defaultPrivacy : INITIAL_STATE.composer?.default_privacy || "unlisted"
        accessToken    : INITIAL_STATE.meta.accessToken
        origin         : INITIAL_STATE.meta.origin || "/"
        maxChars       : INITIAL_STATE.composer?.max_chars
    config[prop] = initial[prop] for prop in [
        "title" , "basename" , "locale" , "root" , "defaultPrivacy" , "accessToken" ,
        "origin" , "maxChars"
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
    config.root.setAttribute "data-snow-display" , config.display.join " "

    #  This loads our `config.locales` into our `Locales` object:
    for locale, data of config.locales
        Locales[locale] = {} unless Locales[locale] instanceof Object
        Locales[locale][message] = value for message, value of data
        
    #  This sets our current locale, defaulting to `"en"`:
    config.locale = "en" unless config.locale?
    config.root.setAttribute "lang" , config.locale
        
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
            document.removeEventListener "LaboratoryAuthorizationReceived" , callback
        document.addEventListener "LaboratoryAuthorizationReceived" , callback

    #  We can only `run()` if Laboratory has finished initializing:
    if Laboratory?.ready then do run
    else document.addEventListener "LaboratoryInitializationReady" , run

window.addEventListener "load" , init