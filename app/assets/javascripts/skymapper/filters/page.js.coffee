window.skymapper_app.filter 'page', ->

  (input, range) ->
    return if isBlank(input)
    return if isBlank(range)
    input.slice(range[0], range[range.length - 1])
