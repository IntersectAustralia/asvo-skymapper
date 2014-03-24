window.skymapper_app.directive 'range', ->

  {
    restrict: 'A',
    require: 'ngModel',
    link: (scope, elem, attr, ctrl) ->

      validate = (value) ->
        rangeValidator = new RangeValidator(attr.range)

        valid = rangeValidator.validate(value)
        ctrl.$setValidity('range', valid)

        value

      ctrl.$parsers.unshift validate

      ctrl.$formatters.unshift validate

      if attr.dependentOn
        scope.$watch attr.dependentOn, ->
          validate(elem.val())
  }

window.skymapper_app.directive 'decimal', ->

  {
    restrict: 'A',
    require: 'ngModel',
    link: (scope, elem, attr, ctrl) ->

      validate = (value) ->
        format = "^-?\\d*(\\.\\d{1,#{attr.decimal}})?$"
        formatValidator = new FormatValidator(format)

        valid = formatValidator.validate(value)
        ctrl.$setValidity('decimal', valid)

        value

      ctrl.$parsers.unshift validate

      ctrl.$formatters.unshift validate

      if attr.dependentOn
        scope.$watch attr.dependentOn, ->
          validate(elem.val())
  }

window.skymapper_app.directive 'minMax', ->

  {
  restrict: 'A',
  require: 'ngModel',
  link: (scope, elem, attr, ctrl) ->

    validate = (value) ->
      minMaxValidator = new MinMaxValidator(attr.minMax)

      valid = minMaxValidator.validate(value)
      ctrl.$setValidity('minMax', valid)

      value

    ctrl.$parsers.unshift validate

    ctrl.$formatters.unshift validate

    if attr.dependentOn
      scope.$watch attr.dependentOn, ->
        validate(elem.val())
  }

window.skymapper_app.directive 'fileRequired', ->

  {
    restrict: 'A'
    require:'ngModel',
    link: (scope, elem, attr, ctrl) ->

      validate = (value) ->

        valid = !isBlank(value)
        ctrl.$setValidity('fileRequired', valid)

        value

      ctrl.$parsers.unshift validate

      ctrl.$formatters.unshift validate

      elem.bind 'change', ->
        validate(elem.val())
        ctrl.$setViewValue(elem.val())
        scope.$apply()
  }

window.skymapper_app.directive 'ravalidate', ->

  {
  restrict: 'A',
  require: 'ngModel',
  link: (scope, elem, attr, ctrl) ->

    validate = (value) ->
      #first check for standard degree format
      format = "^[+]?\\d*(\\.\\d{1,6})?$"
      degreeFormatValidator = new RegexFormatValidator(format)
      hourFormat = "^[0-2][0-9][:\\s][0-6][0-9][:\\s][0-6][0-9](\\.[0-9]{1,5})?$"
      hourFormatValidator = new RegexFormatValidator(hourFormat)
      valid = degreeFormatValidator.validate(value) || hourFormatValidator.validate(value)
      ctrl.$setValidity('ravalidate', valid)
      value

    ctrl.$parsers.unshift validate

    ctrl.$formatters.unshift validate

    if attr.dependentOn
      scope.$watch attr.dependentOn, ->
        validate(elem.val())
  }
window.skymapper_app.directive 'rarange', ->

  {
  restrict: 'A',
  require: 'ngModel',
  link: (scope, elem, attr, ctrl) ->

    validate = (value) ->
      deg_val = ra_to_deg(value)
      rangeValidator = new RangeValidator(attr.rarange)
      valid = rangeValidator.validate(deg_val)
      ctrl.$setValidity('rarange', valid)
      value

    ctrl.$parsers.unshift validate

    ctrl.$formatters.unshift validate

    if attr.dependentOn
      scope.$watch attr.dependentOn, ->
        validate(elem.val())
  }
window.skymapper_app.directive 'decvalidate', ->

  {
  restrict: 'A',
  require: 'ngModel',
  link: (scope, elem, attr, ctrl) ->

    validate = (value) ->
      #first check for standard degree format
      format = "^[+-]?\\d*(\\.\\d{1,6})?$"
      degreeFormatValidator = new RegexFormatValidator(format)
      decFormat = "^[+-]?[0-9][0-9][:\\s][0-6][0-9][:\\s][0-6][0-9](\\.[0-9]{1,5})?$"
      decFormatValidator = new RegexFormatValidator(decFormat)
      valid = degreeFormatValidator.validate(value) || decFormatValidator.validate(value)
      ctrl.$setValidity('decvalidate', valid)
      value

    ctrl.$parsers.unshift validate

    ctrl.$formatters.unshift validate

    if attr.dependentOn
      scope.$watch attr.dependentOn, ->
        validate(elem.val())
  }
window.skymapper_app.directive 'decrange', ->

  {
  restrict: 'A',
  require: 'ngModel',
  link: (scope, elem, attr, ctrl) ->

    validate = (value) ->
      deg_val = dec_to_deg(value)
      rangeValidator = new RangeValidator(attr.decrange)
      valid = rangeValidator.validate(deg_val)
      ctrl.$setValidity('decrange', valid)
      value

    ctrl.$parsers.unshift validate

    ctrl.$formatters.unshift validate

    if attr.dependentOn
      scope.$watch attr.dependentOn, ->
        validate(elem.val())
    }

window.skymapper_app.directive "match", ($parse) ->

  {
    require: "ngModel"
    link: (scope, elem, attrs, ctrl) ->
      
      scope.$watch (->
        $parse(attrs.match)(scope) is ctrl.$modelValue
      ), (currentValue) ->
        ctrl.$setValidity "mismatch", currentValue
        return
      return
  }
