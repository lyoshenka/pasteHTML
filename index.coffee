#!/usr/bin/env coffee

config = require "./config"

sugar = require "sugar"
express = require "express"
jade = require "jade"
minify = require "express-minify"
mongodb = require "mongodb"
jsescape = require "js-string-escape"

wdir = (path) -> "#{__dirname}/#{path}"
formatBytes = (bytes) ->
    return "0 #{sizes[0]}"  if bytes is 0
    unit = ["B", "KB", "MB", "GB", "TB"][parseInt(Math.floor(Math.log(bytes) / Math.log(1024)))]
    Math.round(bytes / Math.pow(1024, i), 2) + " " + unit

mongodb.MongoClient.connect config.db, (err, db) ->
    pastes = db.collection "pastes"
    
    app = express.createServer()
    
    app.configure ->
        app.set "views", wdir "views"
        app.set "view engine", "jade"
        app.set "view options", layout: false
        
        app.use express.bodyParser()
        app.use express.logger()
        
        express.static.mime.define
            "text/coffeescript": ["coffee"]
            "text/stylus": ["styl"]
        
        app.use express.favicon wdir "public/favicon.ico"
        app.use express.compress()
        app.use minify cache: wdir "cache"
        app.use express.static wdir "public"
        app.use express.errorHandler showStack: true, dumpExceptions: false
        app.use (req, res, next) ->
            res.removeHeader "X-Powered-By"
            res.header "Server", "Node.js/#{process.versions.node} Express/#{express.version}"
            next()
    
    app.get "/info", (req, res) ->
        db.stats (err, stats) ->
            res.render "info.jade", locals:
                pastes: stats.objects.format()
    
    app.get "/robots.txt", (req, res) ->
        res.setHeader "Content-Type", "text/plain"
        res.send config.robots
    
    app.get "/", (req, res, next) -> res.render "home.jade"
    
    app.post "/", (req, res, next) ->
        return res.send "Nice try" if req.headers["x-requested-with"] is "XMLHttpRequest"
        
        if typeof req.body.html isnt "string" or req.body.html.length is 0
            return res.render "home.jade", locals:
                msg: "Your paste is empty.";
        if Buffer.byteLength(req.body.html, "utf8") > config.limit
            return res.render "home.jade", locals:
                msg: "Your paste is over #{formatBytes config.limit}. Please minify your HTML."

        id = ""
        for i in [1..config.ids.length]
            id += config.ids.chars.charAt Math.floor(Math.random() * config.ids.chars.length)
        
        pastes.save _id: id, content: req.body.html, (err, doc) ->
            throw err if err
            res.setHeader "Location", "/#{id}"
            res.setHeader "Content-Type", "text/plain"
            res.status 302
            res.send id
    
    app.get "/:id", (req, res, next) ->
        pastes.findOne _id: req.params.id, (err, item) ->
            throw err if err
            if item
                if (req.headers.referer or "").indexOf("pasteht") > -1
                    res.setHeader "X-XSS-Protection", 0
                res.send item.content
            else
                next()
    
    app.use (req, res) ->
        res.status 404
        res.render "home.jade", locals:
            msg: "This paste has been deleted or does not exist."
    
    app.error (err, req, res, next) ->
        res.status 500
        res.render "home.jade", locals:
            msg: jsescape "An error occurred: <pre>#{err.stack}</pre>This error has been logged."
        console.error err.stack
    
    app.listen config.port
    console.log "pasteHTML is running on #{require('os').hostname()}:#{config.port}"
