window.skymapper_app.directive 'range', ->

  {
    restrict: 'A',
    require: 'ngModel',
    link: (scope, elem, attr, ctrl) ->

      ctrl.$parsers.unshift (value) ->
        rangeValidator = new RangeValidator(attr.range)

        valid = rangeValidator.validate(value)
        ctrl.$setValidity('range', valid)

        value

      ctrl.$formatters.unshift (value) ->
        rangeValidator = new RangeValidator(attr.range)
        
        valid = rangeValidator.validate(value)
        ctrl.$setValidity('range', valid)

        value

      if attr.dependentOn
        scope.$watch attr.dependentOn, ->
          rangeValidator = new RangeValidator(attr.range)

          valid = rangeValidator.validate(elem.val())
          ctrl.$setValidity('range', valid)
  }

window.skymapper_app.directive 'decimal', ->

  {
    restrict: 'A',
    require: 'ngModel',
    link: (scope, elem, attr, ctrl) ->

      ctrl.$parsers.unshift (value) ->
        format = "^-?\\d+?(.\\d{0,#{attr.decimal}})?$"
        formatValidator = new FormatValidator(format)

        valid = formatValidator.validate(value)
        ctrl.$setValidity('decimal', valid)

        value

      ctrl.$formatters.unshift (value) ->
        format = "^-?\\d+?(.\\d{0,#{attr.decimal}})?$"
        formatValidator = new FormatValidator(format)

        valid = formatValidator.validate(value)
        ctrl.$setValidity('decimal', valid)

        value

      if attr.dependentOn
        scope.$watch attr.dependentOn, ->
          rangeValidator = new RangeValidator(attr.range)

          valid = rangeValidator.validate(elem.val())
          ctrl.$setValidity('range', valid)
  }
