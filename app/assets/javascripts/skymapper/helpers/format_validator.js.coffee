class @FormatValidator 

  constructor: (@format) ->

  validate: (value) ->
    return false unless typeof @format == 'string'
    return true if isBlank(value)
    return false unless isNumber(value)

    match = clean(value).match(new RegExp(@format))
    return match != null
