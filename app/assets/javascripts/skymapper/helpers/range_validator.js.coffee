class @RangeValidator

  constructor: (range) ->
    @range = @clean(range)

  clean: (value) ->
    value = value.replace(/\s+/g, '') if typeof value == 'string'
    value

  validate: (value) ->
    return false unless typeof @range == 'string'
    return false unless typeof value == 'string'
    return false if isNaN(Number(@clean(value)))

    number = parseFloat(@clean(value))
    return false unless typeof number == 'number'

    regex = /^(\(|\[)(-?\d+(\.\d+)?),(-?\d+)(\)|\])$/
    match = @range.match(regex)

    return false if match == null
    return false unless match.length == 6

    left_bracket = match[1]
    right_bracket = match[5]
    min_range = parseFloat(match[2])
    max_range = parseFloat(match[4])

    return (number > min_range || (left_bracket == '[' && number == min_range)) &&
        (number < max_range || (right_bracket == ']' && number == max_range))

