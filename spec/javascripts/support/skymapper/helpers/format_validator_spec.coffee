#= require skymapper/helpers/format_validator

describe 'FormatValidator', ->

  it 'can validate format', ->
    format = '^-?\\d+?(.\\d{0,5})?$'
    formatValidator = new FormatValidator(format)

    expect(formatValidator.validate('10')).toBe true
    expect(formatValidator.validate('10.12345')).toBe true
    expect(formatValidator.validate('10.123456')).toBe false
    expect(formatValidator.validate('abc')).toBe false
    expect(formatValidator.validate('.')).toBe false

  it 'ignores spaces', ->
    format = '^-?\\d+?(.\\d{0,5})?$'
    formatValidator = new FormatValidator(format)

    expect(formatValidator.validate('  10')).toBe true
    expect(formatValidator.validate('10.12345'  )).toBe true
    expect(formatValidator.validate('  10.123456')).toBe false
    expect(formatValidator.validate('abc  ')).toBe false
    expect(formatValidator.validate('.  ')).toBe false