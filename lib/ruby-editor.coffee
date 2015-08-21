path = require('path')

class RubyEditor
  constructor: (@editor) ->
    @file = @editor?.buffer?.file

  ruby: ->
    @file && @file.path && (path.extname(@file.path) == ".rb")

  mainClass: ->
    @_mainClass ?= @_getMainClass()

  _getMainClass: ->
    content = @editor.getBuffer().cachedText
    match = content.match(/class ([a-zA-Z0-9]+)/)
    match && match[1]

module.exports = RubyEditor
