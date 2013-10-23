class @RangeValidator

  constructor: (range) ->
    @range = clean(range)

  validate: (value) ->
    return false unless typeof @range == 'string'
    regex = /^(\(|\[)(-?\d+(\.\d+)?),(-?\d+)(\)|\])$/
    match = @range.match(regex)
    return false if match == null
    return false unless match.length == 6

    return true if isBlank(value)
    return false unless isNumber(value)
    number = Number(clean(value))

    left_bracket = match[1]
    right_bracket = match[5]
    min_range = Number(match[2])
    max_range = Number(match[4])

    return (number > min_range || (left_bracket == '[' && number == min_range)) &&
        (number < max_range || (right_bracket == ']' && number == max_range))

