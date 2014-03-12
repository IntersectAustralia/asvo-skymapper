class @RegexFormatValidator

  constructor: (@format) ->

  validate: (value) ->
    return false unless typeof @format == 'string'
    return true if isBlank(value)

    match = value.match(new RegExp(@format))
    return match != null
