class SchemaEditors
  constructor: (@subscriptions)->
    @editors = []

  add: (editor, active = true) ->
    if @exclude(editor)
      @editors.push(editor: editor, active: active)
      @subscriptions.add editor.onDidDestroy =>
        @editors = @editors.filter ({editor}) => editor.alive

  addOrActivate: (editor) ->
    @add(editor)
    @activate(editor)

  exclude: (editor) ->
    @find(editor) == null

  include: (editor) ->
    !@exclude(editor)

  includeActive: (editor) ->
    editorObject = @find(editor)
    editorObject && editorObject.active

  find: (editorToLook) ->
    founds = @editors.filter(({editor}) => editor == editorToLook)
    if founds.length > 0 then founds[0] else null

  activate: (editor) ->
    @find(editor)?.active = true

  deactivate: (editor) ->
    @find(editor)?.active = false

module.exports = SchemaEditors
