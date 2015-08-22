{$, jQuery, View} = require 'atom-space-pen-views'

class RailsModelSchemaView extends View
  @content: (schemaContent) ->
    @div class: "rails-model-schema", =>
      @table =>
        @thead =>
          @tr =>
            @th "Name"
            @th "Type"
        @tbody =>
          for {name, type} in schemaContent.attributes
            @tr =>
              @td name
              @td type

  destroy: -> @element.remove()
  getElement: -> @element

module.exports = RailsModelSchemaView
