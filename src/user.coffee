user = ->  #  Renders a user page

    header = undefined    
    
    handleRequest = (response) ->
        return unless response instanceof LPr
        Τ header ,
            Σ "A" , {
                href   : response.header
                target : "_blank"
            } , Σ "IMG" ,
                alt : "Header image for " + (response.displayName or response.account)
                src : response.header
            Σ "A" , {
                href   : response.href
                title  : response.displayName
                target : "_blank"
            } ,
                Σ "IMG"  ,
                    alt : (response.displayName or response.account) + "'s avatar"
                    src : response.avatar
                Σ "H2"   , undefined, response.displayName
                Σ "CODE" , undefined, response.account
            σ "P" , undefined , response.bio

    Τ state.window ,
        header = Σ "HEADER"
        state.timeline = Σ "DIV" , {id : "🌨📜"}

    request = new LPr.Request
        id : state.query
    request.assign handleRequest
    do request.start
    cleanup.push request.stop