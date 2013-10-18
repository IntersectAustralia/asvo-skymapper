window.skymapper_app.filter 'iif', ->

  (input, trueValue, falseValue) ->
    if input
      return trueValue
    else
      return falseValue
