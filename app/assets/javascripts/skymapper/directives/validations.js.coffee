window.skymapper_app.directive("range", ->

  {
    restrict: 'A',
    require: 'ngModel',
    link: (scope, elem, attr, ctrl) ->

      rangeValidator = new RangeValidator(attr.range)

      ctrl.$parsers.unshift (value) ->
        value = $(elem).val()

        valid = rangeValidator.validate(value)
        ctrl.$setValidity('range', valid)

        valid ? value : undefined

      ctrl.$formatters.unshift (value) ->
        value = $(elem).val()
        
        valid = rangeValidator.validate(value)
        ctrl.$setValidity('range', valid)

        value
  }

)

window.skymapper_app.directive("decimal", ->

  {
    restrict: 'A',
    require: 'ngModel',
    link: (scope, elem, attr, ctrl) ->

      format = "^-?\\d+?(.\\d{0,#{attr.decimal}})?$"
      formatValidator = new FormatValidator(format)

      ctrl.$parsers.unshift (value) ->
        value = $(elem).val()

        valid = formatValidator.validate(value)
        ctrl.$setValidity('decimal', valid)

        valid ? value : undefined

      ctrl.$formatters.unshift (value) ->
        value = $(elem).val()

        valid = formatValidator.validate(value)
        ctrl.$setValidity('decimal', valid)

        value
  }
)
