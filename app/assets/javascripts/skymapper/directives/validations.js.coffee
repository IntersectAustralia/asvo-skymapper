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