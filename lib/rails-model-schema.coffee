{ CompositeDisposable } = require "atom"
SchemaEditorsCollection = require "./schema-editors-collection"

module.exports = RailsModelSchema =
  subscriptions: null
  config:
    showImmediately:
      type: "boolean"
      default: true
      description: "Show the schema panel when opening a file."

  serialize: -> {}

  activate: ->
    @subscriptions = new CompositeDisposable
    @editors = new SchemaEditorsCollection(@subscriptions)

    @subscriptions.add atom.commands.add "atom-workspace",
      "rails-model-schema:toggle": => @toggle()

    @subscriptions.add atom.workspace.onDidChangeActivePaneItem (pane) =>
      return unless pane

      enableOnCreate = atom.config.get("rails-model-schema.showImmediately")

      editor = @editors.findByPane(pane) || @editors.add(pane, enabled: enableOnCreate)
      @editors.activateEditor(editor)

  deactivate: ->
    @editor.deactivateCurrentEditors()
    @subscriptions.dispose()

  toggle: ->
    pane = atom.workspace.getActivePaneItem()
    editor = @editors.findByPane(pane)
    editor?.toggle()
