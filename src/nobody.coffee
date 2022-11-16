nobody = ->  #  Renders a non-user page

    AorB = (useB , object , contents) ->
        if useB then Σ "B" , undefined , contents else Σ "A" , object , contents

    Τ state.window,
        Σ "NAV" , {id : "snow-navbar"} ,
            AorB state.location & SHOW_TIMELINE and not (state.location & FROM_PUBLIC) , {
                href   : "#!/"
                target : "_self"
            } , Ε "link.home"
            AorB state.location & SHOW_TIMELINE and state.location & ONLY_LOCAL , {
                href   : "#!/" + Ε "location.local"
                target : "_self"
            } , Ε "link.local"
            AorB state.location & SHOW_TIMELINE and state.location & FROM_PUBLIC and
                not (state.location & ONLY_LOCAL) , {
                    href   : "#!/" + Ε "location.global"
                    target : "_self"
                } , Ε "link.global"
        state.timeline = Σ "DIV" , {id : "🌨📜"}