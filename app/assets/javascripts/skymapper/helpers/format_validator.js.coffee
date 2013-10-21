class @FormatValidator 

  constructor: (@format) ->

  clean: (value) ->
    value = value.replace(/\s+/g, '') if typeof value == 'string'
    value

  validate: (value) ->
    return false unless typeof @format == 'string'
    return false unless typeof value == 'string'
    return false if isNaN(Number(@clean(value)))

    match = @clean(value).match(new RegExp(@format))

    return match != null
