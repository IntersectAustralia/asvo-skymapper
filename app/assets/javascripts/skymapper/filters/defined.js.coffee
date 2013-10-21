window.skymapper_app.filter 'defined', ->

  (input, value1, value2) ->
    if input
      return value1
    else
      return value2
