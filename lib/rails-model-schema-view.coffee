{$, jQuery, View} = require 'atom-space-pen-views'
SchemaService = require './schema-service'

class RailsModelSchemaView extends View
  schemaService: null

  initialize: ->
    @schemaService = new SchemaService

  @content: ->
    @div class: "rails-model-schema", =>
      @h1 "Alive!"

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  toggle: ->
    if @isVisible() then @hide() else @show()

  show: ->
    unless @schemaService.shouldLoadSchema()
      atom.notifications.addWarning(
        "Can only show model schemas inside of a ruby file with a class."
      )
      return

    unless @schemaService.canLoadSchema()
      atom.notifications.addWarning(
        "You need to have a schema.rb file in the top of the project."
      )
      return

    super

module.exports = RailsModelSchemaView
