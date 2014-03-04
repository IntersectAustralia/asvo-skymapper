window.skymapper_app.controller 'SearchController', ['$scope', '$window',

  class SearchController

    constructor: ($scope, $window) ->
      $scope.submitted = false
      $scope.form = {}

      $scope.fetchResults = (form, url) ->
        $scope.submitted = true
        if $scope[form].$valid
          params = {}
          for key, value of $scope.form
            params[key] = clean(value) unless isBlank(value)
          args = encodeQueryParams(params)
          $window.location.href = "#{url}?#{args}"

      $scope.submit = (form, event) ->
        $scope.submitted = true
        event.preventDefault() unless $scope[form].$valid

      $scope.setInput = (field, value) ->
        $scope.form[field] = value unless isBlank(value)

]