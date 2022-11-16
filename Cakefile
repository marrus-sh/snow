fs     = require "fs"
{exec} = require "child_process"

files = [
    "index"
    "constants"
    "Locales/index"
    "Locales/en"
    "init"
    "helpers"
    "authorize"
    "go"
    "locate"
    "notfound"
    "user"
    "nobody"
    "timeline"
    "post"
]

process = (contents) ->
    console.log "Joining files..."
    fs.writeFile "dist/snow.coffee" , contents.join('\n\n') , 'utf8' , (err) ->
        throw err if err
        console.log "Compiling CoffeeScript..."
        exec "coffee --compile dist/snow.coffee" , (err , stdout , stderr) ->
            throw err if err
            console.log stdout + stderr if stdout or stderr
            console.log "Minifying JavaScript..."
            exec "uglifyjs dist/snow.js --comments all --compress --output dist/snow.min.js" , (err , stdout , stderr) ->
                throw err if err
                console.log stdout + stderr if stdout or stderr
                console.log "Compiling Sass..."
                exec "sass --no-cache --sourcemap=none styling/index.scss dist/snow.css" , (err , stdout , stderr) ->
                    throw err if err
                    console.log stdout + stderr if stdout or stderr
                    console.log "...Done."

build = ->
    contents = new Array remaining = files.length
    console.log "Reading files..."
    for file , index in files
        do (file , index) ->
            fs.readFile "src/#{file}.coffee" , "utf8" , (err , fileContents) ->
                throw err if err
                contents[index] = fileContents
                process contents if --remaining is 0

buildAndWatch = ->
    do build
    fs.watch "src/" , interval: 200 , (eventType , filename) ->
        if eventType is 'change'
            console.log "File `src/#{filename}` changed, rebuilding..."
            do build
    fs.watch "styling/" , interval: 200 , (eventType , filename) ->
        if eventType is 'change'
            console.log "File `styling/#{filename}` changed, rebuilding..."
            do build

task "build", "Build a single application file from the source files", build
task "build:watch", "Watch and continually rebuild a single application file from the source files", buildAndWatch
