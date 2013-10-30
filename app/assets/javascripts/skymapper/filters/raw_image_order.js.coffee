window.skymapper_app.filter 'rawImageOrder', ->

  (input, fields) ->
    return if isBlank(input)
    return if isBlank(fields)

    input.slice(0).sort (obj1, obj2) -> rawImageOrder(fields, obj1, obj2)

