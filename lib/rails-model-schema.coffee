SchemaService = require './schema-service'
RailsModelSchemaView = require './rails-model-schema-view'
{CompositeDisposable} = require 'atom'
PathWatcher = require 'pathwatcher'

module.exports = RailsModelSchema =
  railsModelSchemaView: null
  subscriptions: null
  schemaWatcher: null

  activate: ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
      'rails-model-schema:toggle': => @toggle()

    @subscriptions.add atom.workspace.onDidChangeActivePaneItem (editor) =>
      @railsModelSchemaView?.destroy()
      @initializeView(false)

  deactivate: ->
    @schemaWatcher?.close()
    @subscriptions.dispose()
    @railsModelSchemaView.destroy()

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
        atom.workspace.addRightPanel(item: @railsModelSchemaView.getElement())

  toggle: ->
    if @railsModelSchemaView && @railsModelSchemaView.isVisible()
      @railsModelSchemaView.destroy()
      @schemaWatcher?.close()
    else
      @initializeView(true)
