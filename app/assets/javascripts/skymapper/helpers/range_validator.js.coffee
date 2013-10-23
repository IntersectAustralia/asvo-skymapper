class @RangeValidator

  constructor: (range) ->
    @range = clean(range)

  validate: (value) ->
    # validate range format
    return false unless typeof @range == 'string'
    regex = /^(\(|\[)([^,]*),([^,]*)(\)|\])$/
    match = @range.match(regex)
    return false if match == null
    return false unless match.length == 5

    # validate value
    return true if isBlank(value)
    return false unless isNumber(value)
    number = Number(clean(value))

    # validate min and max range
    left_bracket = match[1]
    right_bracket = match[4]
    min_range = Number(match[2])
    max_range = Number(match[3])

    return (!isNumber(min_range) || number > min_range || (left_bracket == '[' && number == min_range)) &&
        (!isNumber(max_range) || number < max_range || (right_bracket == ']' && number == max_range))

