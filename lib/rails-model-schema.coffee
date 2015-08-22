SchemaService = require './schema-service'
RailsModelSchemaView = require './rails-model-schema-view'
{CompositeDisposable} = require 'atom'

module.exports = RailsModelSchema =
  railsModelSchemaView: null
  subscriptions: null

  activate: ->
    @initializeView()

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'rails-model-schema:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()
    @railsModelSchemaView.destroy()

  # We don't want to serialize :)
  serialize: -> {}

  initializeView: ->
    schemaService = new SchemaService
    warn = atom.notifications.addWarning.bind(atom.notifications)

    if not schemaService.shouldLoadSchema()
      warn "Can only show model schemas inside of a ruby file with a class."
    else if not schemaService.canLoadSchema()
      warn "You need to have a schema.rb file in the top of the project."
    else
      content = schemaService.schemaContent()
      if not content.tableFound
        warn "No table \"#{content.tableName}\" in schema file."
      else
        @railsModelSchemaView = new RailsModelSchemaView(content)
        atom.workspace.addRightPanel(item: @railsModelSchemaView.getElement())

  toggle: ->
    if @railsModelSchemaView && @railsModelSchemaView.isVisible()
      @railsModelSchemaView.destroy()
    else
      @initializeView()
