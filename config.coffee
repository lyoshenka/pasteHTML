module.exports =
    port: process.env.PORT or 8080
    db: process.env.MONGODB_URI or "mongodb://127.0.0.1:27017/pastehtml"
    
    limit: 131072  # Paste size limit in bytes
    ids:           # Paste ID length and acceptable characters
        length: 5
        chars: "ABCDEFGH#{#I}JKLMN#{#O}PQRSTUVWXYZabcdefgh#{#i}jk#{#l}mnopqrstuvwxyz0123456789012345678901234567890123456789"
