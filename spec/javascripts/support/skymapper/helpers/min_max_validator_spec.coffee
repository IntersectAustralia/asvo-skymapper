#= require skymapper/helpers/min_max_validator

describe 'MinMaxValidator', ->

  it 'can validate max', ->
    minMaxValidator = new MinMaxValidator('0')
    expect(minMaxValidator.validate('1')).toEqual true
    expect(minMaxValidator.validate('0')).toEqual false
    expect(minMaxValidator.validate('-1')).toEqual false
    expect(minMaxValidator.validate(' -1  ')).toEqual false

  it 'allows undefined min', ->
    minMaxValidator = new MinMaxValidator(undefined)
    expect(minMaxValidator.validate('1')).toEqual true
    expect(minMaxValidator.validate('0')).toEqual true
    expect(minMaxValidator.validate('-1')).toEqual true
    expect(minMaxValidator.validate(' -1  ')).toEqual true

  it 'allows empty min', ->
    minMaxValidator = new MinMaxValidator('   ')
    expect(minMaxValidator.validate('1')).toEqual true
    expect(minMaxValidator.validate('0')).toEqual true
    expect(minMaxValidator.validate('-1')).toEqual true
    expect(minMaxValidator.validate(' -1  ')).toEqual true

  it 'allows undefined and empty values', ->
    minMaxValidator = new MinMaxValidator('0')
    expect(minMaxValidator.validate(undefined )).toEqual true
    expect(minMaxValidator.validate('       ')).toEqual true