class @MinMaxValidator

  constructor: (@min) ->

  validate: (max) ->
    return true if isBlank(@min)
    return true unless isNumber(@min)
    return true if isBlank(max)
    return false unless isNumber(max)
    return Number(clean(max)) > Number(clean(@min))