#= require skymapper/helpers/range_validator

describe 'RangeValidator', ->

  it 'can validate inclusive range', ->
    range = '[10, 20]'
    validator = new RangeValidator(range)

    expect(validator.validate('10')).toEqual true
    expect(validator.validate('20')).toEqual true
    expect(validator.validate('15')).toEqual true
    expect(validator.validate('9.9')).toEqual false
    expect(validator.validate('20.1')).toEqual false
    expect(validator.validate(undefined)).toEqual false
    expect(validator.validate('')).toEqual false
    expect(validator.validate('12a')).toEqual false
    expect(validator.validate('.')).toEqual false

  it 'can validate left inclusive range', ->
    range = '(10, 20]'
    validator = new RangeValidator(range)

    expect(validator.validate('10')).toEqual false
    expect(validator.validate('20')).toEqual true
    expect(validator.validate('15')).toEqual true
    expect(validator.validate('9.9')).toEqual false
    expect(validator.validate('20.1')).toEqual false
    expect(validator.validate(undefined)).toEqual false
    expect(validator.validate('')).toEqual false
    expect(validator.validate('12a')).toEqual false
    expect(validator.validate('.')).toEqual false

  it 'can validate right inclusive range', ->
    range = '[10, 20)'
    validator = new RangeValidator(range)

    expect(validator.validate('10')).toEqual true
    expect(validator.validate('20')).toEqual false
    expect(validator.validate('15')).toEqual true
    expect(validator.validate('9.9')).toEqual false
    expect(validator.validate('20.1')).toEqual false
    expect(validator.validate(undefined)).toEqual false
    expect(validator.validate('')).toEqual false
    expect(validator.validate('12a')).toEqual false
    expect(validator.validate('.')).toEqual false

  it 'can validate non inclusive range', ->
    range = '(10, 20)'
    validator = new RangeValidator(range)

    expect(validator.validate('10')).toEqual false
    expect(validator.validate('20')).toEqual false
    expect(validator.validate('15')).toEqual true
    expect(validator.validate('9.9')).toEqual false
    expect(validator.validate('20.1')).toEqual false
    expect(validator.validate(undefined)).toEqual false
    expect(validator.validate('')).toEqual false
    expect(validator.validate('12a')).toEqual false
    expect(validator.validate('.')).toEqual false

  it 'cannot validate undefined range and value', ->
    range = undefined
    validator = new RangeValidator(range)

    expect(validator.validate('10')).toEqual false
    expect(validator.validate('20')).toEqual false
    expect(validator.validate('15')).toEqual false
    expect(validator.validate('9.9')).toEqual false
    expect(validator.validate('20.1')).toEqual false
    expect(validator.validate(undefined)).toEqual false
    expect(validator.validate('')).toEqual false
    expect(validator.validate('12a')).toEqual false
    expect(validator.validate('.')).toEqual false

  it 'cannot validate malformed range and defined value', ->
    range = '(12],2]'
    validator = new RangeValidator(range)

    expect(validator.validate('10')).toEqual false
    expect(validator.validate('20')).toEqual false
    expect(validator.validate('15')).toEqual false
    expect(validator.validate('9.9')).toEqual false
    expect(validator.validate('20.1')).toEqual false
    expect(validator.validate(undefined)).toEqual false
    expect(validator.validate('')).toEqual false
    expect(validator.validate('12a')).toEqual false
    expect(validator.validate('.')).toEqual false

  it 'ignores white spaces', ->
    range = '[   10    , 20    ]'
    validator = new RangeValidator(range)
    
    expect(validator.validate('  10')).toEqual true
    expect(validator.validate('20  ')).toEqual true
    expect(validator.validate('  15')).toEqual true
    expect(validator.validate('9.9  ')).toEqual false
    expect(validator.validate('  20.1')).toEqual false
    expect(validator.validate(undefined)).toEqual false
    expect(validator.validate('   ')).toEqual false
    expect(validator.validate('  12a')).toEqual false
    expect(validator.validate('  .')).toEqual false

  it 'allows negative ranges', ->
    range = '[   - 20    , -   10    ]'
    validator = new RangeValidator(range)
    
    expect(validator.validate('  -  10  ')).toEqual true
    expect(validator.validate('  -  20  ')).toEqual true
    expect(validator.validate('  -  15  ')).toEqual true
    expect(validator.validate('  -  9.9  ')).toEqual false
    expect(validator.validate('  -  20.1  ')).toEqual false
    expect(validator.validate(undefined)).toEqual false
    expect(validator.validate('')).toEqual false
    expect(validator.validate('-12a')).toEqual false
    expect(validator.validate('.')).toEqual false
