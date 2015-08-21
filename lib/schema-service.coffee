RubyEditor = require('./ruby-editor')
fs = require('fs')

class SchemaService
  shouldLoadSchema: ->
    modelEditor = new RubyEditor(atom.workspace.getActivePaneItem())
    modelEditor.ruby() && modelEditor.mainClass()?

  canLoadSchema: ->
    relativeSchemaLocation = atom.config.get("rails-model-schema.relativeSchemaLocation")
    atom.project.getPaths().some (path) ->
      fs.existsSync("#{path}/#{relativeSchemaLocation}")

module.exports = SchemaService
