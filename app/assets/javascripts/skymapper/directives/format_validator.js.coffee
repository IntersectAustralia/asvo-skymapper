class @FormatValidator 

  constructor: (@format) ->

  validate: (value) ->
    return false unless typeof @format == 'string'
    return false unless typeof value == 'string'

    match = value.match(new RegExp(@format))

    return match != null
