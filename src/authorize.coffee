authorize = ->  #  Creates the authorization window, prompting users for their instance

    handleEvent = (event) ->  #  Requests authorization from the provided instance if possible
        if (
            event.type is "keypress" and event.target is input and (
                event.key is "Enter" or event.code is "Enter" or event.keyCode is 0x0D
            ) or event.type is "click" and event.target is button
        ) and input.value.length and input.validity.valid
            (
                new LAu.Request
                    name     : config.title
                    origin   : "https://" + input.value
                    redirect : config.basename
                    scope    : LAu.Scope.READWRITEFOLLOW
            ).start window.open "about:blank", "SnowOAuth"
            input.value = ""
    
    #  This fills the root element with our authorization window:
    Τ config.root ,
        Σ "DIV" , {id : "🌨🔓"} ,
            Σ "H1" , undefined , Ε "auth.query"
            Σ "P" , undefined ,
                (Ε "auth.username") + "@"
                input = Σ "INPUT" ,
                    pattern     : "[0-9A-Za-z\\-\\.]+(\\:[0-9]{1,4})?"
                    placeholder : Ε "auth.placeholder"
                button = Σ "BUTTON" , undefined , "GO!"
    input.addEventListener "keypress" , handleEvent
    button.addEventListener "click" , handleEvent