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
Σ = (name , attributes , children...) ->
    elt = document.createElement String name
    if attributes is Object attributes
        for attribute , value of attributes when value? and value isnt off
            elt.setAttribute attribute , if value is on then "" else value
    for child in children when child?
        elt.appendChild (
            if child instanceof Node then child else document.createTextNode String child
        )
    return elt
    
#  The lowercase version σ uses innerHTML instead:
σ = (name , attributes , innerHTML) ->
    elt = document.createElement String name
    if attributes is Object attributes
        for attribute , value of attributes when value? and value isnt off
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
        element.insertBefore (  #  You can call τ with a this value to say where to put nodes
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
