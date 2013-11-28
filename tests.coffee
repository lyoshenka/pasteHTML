#!/usr/bin/env coffee
# Some shitty tests

console.log "Starting pasteHTML"
require "./"
config = require "./config"
request = require "request"

url = "http://localhost:#{config.port}"

setTimeout ->
    # GET /
    request.get url, (err, response, body) ->
        throw err if err
        console.log "  TEST: GET / " + if body.indexOf("<!DOCTYPE") isnt -1 then "passed" else "failed"
    
    # Invalid post request
    request.post url, (err, response, body) ->
        console.log "  TEST: Invalid post request " + if body.indexOf("Your paste is empty.") isnt -1 then "passed" else "failed"
    
    # Express-minify
    request.get url + "/css/main.styl", (err, response, body) ->
        console.log "  TEST: Express-minify " + if body.indexOf("@font-face") isnt -1 then "passed" else "failed"
    
    # Save paste
    random = "#{Math.random()}"
    request
        uri: url + "/"
        method: "POST"
        form:
          html: random
    , (err, response, body) ->
        throw err if err
        request.get url + "/#{body}", (err, response2, body2) ->
            throw err if err
            console.log "  TEST: Save paste " + if body2 is random then "passed" else "failed"
            process.exit()
, 5000
