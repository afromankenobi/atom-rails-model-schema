RubyEditor = require('./ruby-editor')
fs = require('fs')

class SchemaService
  shouldLoadSchema: ->
    modelEditor = new RubyEditor(atom.workspace.getActivePaneItem())
    modelEditor.ruby() && modelEditor.mainClass()?

  canLoadSchema: ->
    relativeSchemaLocation = "schema.rb" # TODO: Move to Configuration

    atom.project.getPaths().some (path) ->
      fs.existsSync("#{path}/#{relativeSchemaLocation}")

module.exports = SchemaService
