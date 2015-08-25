{$, jQuery, View} = require 'atom-space-pen-views'

class RailsModelSchemaView extends View
  initialize: ->
    @on "click", ({target}) =>
      if $(target).is("tr.attribute") || $(target).closest("tr.attribute").length > 0
        text = $(target).text()
        atom.clipboard.write(text)

  @content: (schemaContent) ->
    @div class: "rails-model-schema", =>
      @p "Click on each cell to copy his value:"
      @table =>
        @thead =>
          @tr =>
            @th "Name"
            @th "Type"
        @tbody =>
          for {name, type} in schemaContent.attributes
            @tr class: "attribute", =>
              @td =>
                @span class: "attribute-name", name
              @td type

  destroy: -> @element.remove()
  getElement: -> @element

module.exports = RailsModelSchemaView
