module.exports =
    port: process.env.PORT or 8080
    db: process.env.MONGODB_URI or "mongodb://localhost/pastehtml"
    
    # "Server" HTTP header
    server: """
        Node.js/#{process.versions.node} Express/#{require("express").version} (#{process.platform})
    """
    
    # Paste size limit in bytes
    limit: 131072
    ids:
        # Paste ID length and acceptable characters
        length: 5
        chars: "ABCDEFGH#{#I}JKLMN#{#O}PQRSTUVWXYZabcdefgh#{#i}jk#{#l}mnopqrstuvwxyz0123456789012345678901234567890123456789"
