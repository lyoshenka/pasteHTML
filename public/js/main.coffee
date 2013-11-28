(($, ace, window, document) ->
    $ ->
        textarea = $ "textarea"
        
        def = textarea.val()
        
        #($ "<div id='editor'></div>").insertAfter "form"
        textarea.hide()
        
        editor = ace.edit("editor")
        session = editor.getSession()
        
        session.setMode("ace/mode/html");
        
        reset = ->
            session.setValue def
            editor.gotoLine 11, 12
            session.selection.selectTo 10, 24
            editor.focus()
        reset()
        
        ($ "input[type='reset']").click reset
        ($ "input[type='submit']").click ->
            textarea.val session.getValue()
        setInterval (-> textarea.val session.getValue()), 600
        
        ($ "#info").attr "href", "javascript:TINY.box.show({url:'/info',topsplit:3,opacity:90})"
        ($ "#info").attr "target", "_self"
) jQuery, ace, window, document