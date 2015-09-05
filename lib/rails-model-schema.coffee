SchemaService = require './schema-service'
RailsModelSchemaView = require './rails-model-schema-view'
{CompositeDisposable} = require 'atom'
PathWatcher = require 'pathwatcher'
SchemaEditors = require './schema-editors'

module.exports = RailsModelSchema =
  railsModelSchemaView: null
  rightPanel: null
  subscriptions: null
  schemaWatcher: null
  config:
    showImmediately:
      type: 'boolean'
      default: true
      description: 'Show the schema panel when opening a file.'

  activate: ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @editors = new SchemaEditors(@subscriptions)

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
      'rails-model-schema:toggle': => @toggle()

    @subscriptions.add atom.workspace.onDidChangeActivePaneItem (editor) =>
      @destroyRightPanel()

      if @editors.includeActive(editor)
        @initializeView(false)
      else if @editors.exclude(editor)
        if atom.config.get('rails-model-schema.showImmediately')
          @initializeView(false)

  deactivate: ->
    @schemaWatcher?.close()
    @subscriptions.dispose()
    @destroyRightPanel()

  # We don't want to serialize :)
  serialize: -> {}

  initializeView: (displayNotifications) ->
    schemaService = new SchemaService
    warn = (args...) ->
      if displayNotifications
        atom.notifications.addWarning.apply(atom.notifications, args)

    if not schemaService.shouldLoadSchema()
      warn "Can only show model schemas inside of a ruby file with a class."
    else if not schemaService.canLoadSchema()
      warn "You need to have a schema.rb file in the top of the project."
    else
      content = schemaService.schemaContent()
      if not content.tableFound
        warn "No table \"#{content.tableName}\" in schema file."
      else
        @schemaWatcher?.close()
        @schemaWatcher = PathWatcher.watch schemaService.schemaFile(), (event) =>
          @railsModelSchemaView?.destroy()
          @initializeView(false)

        @railsModelSchemaView = new RailsModelSchemaView(content)
        @rightPanel = atom.workspace.addRightPanel(item: @railsModelSchemaView.getElement())
        @editors?.addOrActivate(atom.workspace.getActivePaneItem())

        return true

    return false

  toggle: ->
    if @railsModelSchemaView && @railsModelSchemaView.isVisible()
      @editors?.deactivate(atom.workspace.getActivePaneItem())
      @destroyRightPanel()
      @schemaWatcher?.close()
    else
      @initializeView(true)

  destroyRightPanel: ->
    @railsModelSchemaView?.destroy()
    @rightPanel?.destroy()
