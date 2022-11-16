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
        Σ "ARTICLE" , undefined ,
            Σ "HEADER" , undefined ,
                Σ "A" , {
                    href   : "#!/" + (Ε "location.user") + "/" + status.author.id
                    target : "_self"
                } , Σ "IMG" ,
                    alt: (status.author.displayName or status.author.account) + "'s avatar"
                    src: status.author.avatar
                Σ "A" , {
                    href   : "#!/" + (Ε "location.user") + "/" + status.author.id
                    target : "_self"
                } ,
                    Σ "B"    , undefined , status.author.displayName
                    Σ "CODE" , undefined , status.author.localAccount
            Σ "DIV" , {
                class               : "🌨📰"
                "data-snow-message" : if status.message then status.message
            } ,
                if status.mediaAttachments?.length then Σ "A", {
                    href   : 
                        "#!/" + [
                            (Ε "location.user"), status.author.id, status.id
                        ].join "/"
                    target : "_self"
                } , Σ "FIGURE" , {
                    "data-snow-attachment-count" : status.mediaAttachments.length
                    "data-snow-nsfw"             : !!status.isNSFW
                } , (
                    for attachment in status.mediaAttachments then do ->
                        media =
                            if attachment.type & LAt.Type.VIDEO then Σ "VIDEO" ,
                                controls : attachment.type isnt LAt.Type.GIFV
                                loop     : attachment.type is LAt.Type.GIFV
                                muted    : attachment.type is LAt.Type.GIFV
                                poster   : attachment.preview
                                src      : attachment.href
                            else Σ "IMG", {src : attachment.href}
                        media.addEventListener "load" , ->
                            tl.scrollTop = tl.scrollHeight - scrollBottom
                        if attachment.type is LAt.Type.GIFV
                            media.addEventListener "mouseover"  , media.play
                            media.addEventListener "mouseleave" , media.pause
                        return media
                )...
                σ "SECTION" , undefined , status.content
            Σ "FOOTER" , undefined ,
                Σ "A" , {
                    href   : "#!/" + [
                        (Ε "location.user") , status.author.id , status.id
                    ].join "/"
                    target : "_self"
                } , status.datetime
                (
                    if status.application then [
                        " • "
                        if status.application.href then Σ "A" , {
                            href   : status.application.href
                            target : "_blank"
                        } , status.application.name else status.application.name
                    ] else []
                )...

    handleRequest = (response) ->
        return unless response instanceof LTi
        if tl.scrollTop is tl.scrollHeight - tl.clientHeight then doScroll = yes
        if response.length
            τ tl , (
                for i in [response.posts.length - 1 .. 0] then renderStatus response.posts[i]
            )...
            if doScroll then tl.scrollTop = tl.scrollHeight - tl.clientHeight
            update this
        else timeout = window.setTimeout @start, 3000

    handleBackRequest = (response) ->
        return unless response instanceof LTi
        scrollBottom = tl.scrollHeight - tl.scrollTop
        if response.length then τ.call tl.firstElementChild , tl , (
            for status in response.posts then renderStatus status
        )...
        tl.scrollTop = tl.scrollHeight - scrollBottom  

    request = new LTi.Request
        type: switch
            when state.location & FROM_PUBLIC then LTi.Type.PUBLIC
            when state.location & FROM_TAG    then LTi.Type.HASHTAG
            when state.location & FROM_USER   then LTi.Type.ACCOUNT
            else LTi.Type.HOME
        query: if state.location & FROM_USER or state.location & FROM_TAG then state.query
        isLocal: state.location & ONLY_LOCAL
        #  Media and reply bools will go here eventually tho
    request.assign handleRequest
    do request.start
    
    backRequest = undefined
    
    tl.addEventListener "scroll" , -> if tl.scrollTop < 32 and request.response
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
