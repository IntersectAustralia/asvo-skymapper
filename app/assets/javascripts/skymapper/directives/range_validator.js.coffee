class @RangeValidator

  constructor: (@range) ->

  validate: (value) ->
    return false unless typeof @range == 'string'
    return false unless typeof value == 'string'

    number = parseFloat(value)
    return false unless typeof number == 'number'

    regex = /^(\(|\[)\s*(\d+)\s*,\s*(\d+)\s*(\)|\])$/
    match = @range.match(regex)

    return false if match == null
    return false unless match.length == 5

    left_bracket = match[1]
    right_bracket = match[4]
    min_range = parseFloat(match[2])
    max_range = parseFloat(match[3])

    return (number > min_range || (left_bracket == '[' && number == min_range)) &&
    	(number < max_range || (right_bracket == ']' && number == max_range))