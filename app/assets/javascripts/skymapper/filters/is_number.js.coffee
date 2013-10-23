window.skymapper_app.filter 'isNumber', ->

  (input, value1, value2) ->
    if isNumber(input)
      return value1
    else
      return value2
