(($, ace, window, document) -> $ ->
    textarea = ($ "textarea").hide()
    
    def = textarea.val()
    
    editor = ace.edit "editor"
    session = editor.getSession()
    
    session.setMode "ace/mode/html"
    
    reset = ->
        editor.focus()
        session.setValue def
        # Select "Hello World!"
        editor.gotoLine 11, 12
        session.selection.selectTo 10, 24
    reset()
    
    # Save the code to textarea so user can restore a closed editor tab
    setInterval (-> textarea.val session.getValue()), 600
    
    ($ "input[type='reset']").click reset
    ($ "input[type='submit']").click ->
        textarea.val session.getValue()
    
    ($ "#info").attr 
        href: "javascript:TINY.box.show({url:'/info',topsplit:3,opacity:90})"
        target: "_self"
    
) jQuery, ace, window, document
