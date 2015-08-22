{pluralize, underscore} = require('inflection')

class SchemaContent
  constructor: (modelClass) ->
    @attributes = []
    @schemaFound = false
    @tableFound = false
    @tableScanned = false
    @tableName = underscore(pluralize(modelClass))

  fill: (schemaContent) ->
    lines = schemaContent.toString().split(/\n/)
    for line in lines
      @fillFromLine(line)

  fillFromLine: (line) ->
    { schemaRegexp, tableRegexp, columnRegexp, endRegexp } = @regularExpressions()

    if schemaRegexp.test(line)
      @schemaFound = true
    else if @schemaFound
      if tableRegexp.test(line)
        @tableFound = true
      else if @tableFound && !@tableScanned
        if matches = columnRegexp.exec(line)
          @push(type: matches[1], name: matches[2])
        else if endRegexp.test(line)
          @tableScanned = true

  regularExpressions: ->
    {
      schemaRegexp: /ActiveRecord::Schema\.define\(version: [\d]+\) do/,
      tableRegexp: ///create_table\s"#{@tableName}"[\w\W]+do\s*\|t\|///,
      columnRegexp: /\bt\.([a-zA-Z_]+)[\W]+"([a-zA-Z_]+)"[^\n]*/,
      endRegexp: /^[\s]+end$/
    }

  push: ({type, name})->
    @attributes.push(type: type, name: name)

module.exports = SchemaContent
