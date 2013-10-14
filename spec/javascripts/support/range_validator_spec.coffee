#= require skymapper/directives/range_validator

describe 'RangeValidator', ->

  it 'can validate inclusive range', ->
    range = '[10, 20]'
    validator = new RangeValidator(range)

    expect(validator.validate('10')).toBe true
    expect(validator.validate('20')).toBe true
    expect(validator.validate('15')).toBe true
    expect(validator.validate('9.9')).toBe false
    expect(validator.validate('20.1')).toBe false
    expect(validator.validate(undefined)).toBe false
    expect(validator.validate('')).toBe false
    expect(validator.validate('abc')).toBe false

  it 'can validate left inclusive range', ->
    range = '(10, 20]'
    validator = new RangeValidator(range)

    expect(validator.validate('10')).toBe false
    expect(validator.validate('20')).toBe true
    expect(validator.validate('15')).toBe true
    expect(validator.validate('9.9')).toBe false
    expect(validator.validate('20.1')).toBe false
    expect(validator.validate(undefined)).toBe false
    expect(validator.validate('')).toBe false
    expect(validator.validate('abc')).toBe false

  it 'can validate right inclusive range', ->
    range = '[10, 20)'
    validator = new RangeValidator(range)

    expect(validator.validate('10')).toBe true
    expect(validator.validate('20')).toBe false
    expect(validator.validate('15')).toBe true
    expect(validator.validate('9.9')).toBe false
    expect(validator.validate('20.1')).toBe false
    expect(validator.validate(undefined)).toBe false
    expect(validator.validate('')).toBe false
    expect(validator.validate('abc')).toBe false

  it 'can validate non inclusive range', ->
    range = '(10, 20)'
    validator = new RangeValidator(range)

    expect(validator.validate('10')).toBe false
    expect(validator.validate('20')).toBe false
    expect(validator.validate('15')).toBe true
    expect(validator.validate('9.9')).toBe false
    expect(validator.validate('20.1')).toBe false
    expect(validator.validate(undefined)).toBe false
    expect(validator.validate('')).toBe false
    expect(validator.validate('abc')).toBe false

  it 'cannot validate undefined range and value', ->
    range = undefined
    validator = new RangeValidator(range)

    expect(validator.validate('10')).toBe false
    expect(validator.validate('20')).toBe false
    expect(validator.validate('15')).toBe false
    expect(validator.validate('9.9')).toBe false
    expect(validator.validate('20.1')).toBe false
    expect(validator.validate(undefined)).toBe false
    expect(validator.validate('')).toBe false

  it 'cannot validate malformed range and defined value', ->
    range = '(12],2]'
    validator = new RangeValidator(range)

    expect(validator.validate('10')).toBe false
    expect(validator.validate('20')).toBe false
    expect(validator.validate('15')).toBe false
    expect(validator.validate('9.9')).toBe false
    expect(validator.validate('20.1')).toBe false
    expect(validator.validate(undefined)).toBe false
    expect(validator.validate('')).toBe false

  it 'ignores white spaces', ->
    range = '[   10    , 20    ]'
    validator = new RangeValidator(range)
    
    expect(validator.validate('10')).toBe true
    expect(validator.validate('20')).toBe true
    expect(validator.validate('15')).toBe true
    expect(validator.validate('9.9')).toBe false
    expect(validator.validate('20.1')).toBe false
    expect(validator.validate(undefined)).toBe false
    expect(validator.validate('')).toBe false
    expect(validator.validate('abc')).toBe false
