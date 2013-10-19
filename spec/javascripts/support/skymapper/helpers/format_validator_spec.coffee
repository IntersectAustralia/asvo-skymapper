#= require skymapper/helpers/format_validator

describe 'FormatValidator', ->

  it 'can validate format', ->
    format = '^-?\\d*(\\.\\d{1,5})?$'
    formatValidator = new FormatValidator(format)

    expect(formatValidator.validate('10')).toEqual true
    expect(formatValidator.validate('10.12345')).toEqual true
    expect(formatValidator.validate('.12345')).toEqual true
    expect(formatValidator.validate('10.123456')).toEqual false
    expect(formatValidator.validate('abc')).toEqual false
    expect(formatValidator.validate('.')).toEqual false
    expect(formatValidator.validate('1.')).toEqual false

  it 'ignores spaces', ->
    format = '^-?\\d*(\\.\\d{1,5})?$'
    formatValidator = new FormatValidator(format)

    expect(formatValidator.validate('  10')).toEqual true
    expect(formatValidator.validate('10.12345'  )).toEqual true
    expect(formatValidator.validate('  .12345  ')).toEqual true
    expect(formatValidator.validate('  10.123456')).toEqual false
    expect(formatValidator.validate('abc  ')).toEqual false
    expect(formatValidator.validate('.  ')).toEqual false
    expect(formatValidator.validate('  1.  ')).toEqual false