notfound = ->  #  Renders the "Not Found" page
    state.timeline = null
    Τ state.window ,
        Σ "DIV" , {id : "🌨🛇"} ,
            Σ "H2" , null , Ε "notfound.notfound"
            Σ "P"  , null , Ε "notfound.message"