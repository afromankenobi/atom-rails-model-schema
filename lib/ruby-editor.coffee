path = require "path"
fs = require "fs"

SCHEMA_FILE = "db/schema.rb"

findFile = (directory, file) ->
  location = path.join(directory, file)
  if fs.existsSync(location)
    location
  else
    parentLocation = path.resolve(directory, "..")
    if directory != parentLocation
      findFile(parentLocation, file)

class RubyEditor
  constructor: (@editor) ->
    @file = @editor?.buffer?.file

  ruby: ->
    @file && @file.path && (path.extname(@file.path) == ".rb")

  mainClass: ->
    @_mainClass ?= @_getMainClass()

  schemaFile: ->
    @_schemaFile ?= @_getSchemaFile()

  _getSchemaFile: ->
    @file && @file.path && findFile(path.dirname(@file.path), SCHEMA_FILE)

  _getMainClass: ->
    content = @editor.getBuffer().cachedText
    match = content.match(/class ([a-zA-Z0-9]+)/)
    match && match[1]

module.exports = RubyEditor
