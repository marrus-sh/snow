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
        when "" , undefined then HOME
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
                when "" , undefined then USER
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
    