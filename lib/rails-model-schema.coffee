RailsModelSchemaView = require './rails-model-schema-view'
{CompositeDisposable} = require 'atom'

module.exports = RailsModelSchema =
  railsModelSchemaView: null
  subscriptions: null

  config:
    relativeSchemaLocation:
      type: 'string'
      default: 'schema.rb'

  activate: (state) ->
    @railsModelSchemaView = new RailsModelSchemaView(state.railsModelSchemaViewState)
    atom.workspace.addRightPanel(item: @railsModelSchemaView.getElement())

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'rails-model-schema:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()
    @railsModelSchemaView.destroy()

  serialize: ->
    railsModelSchemaViewState: @railsModelSchemaView.serialize()

  toggle: ->
    @railsModelSchemaView.toggle()
