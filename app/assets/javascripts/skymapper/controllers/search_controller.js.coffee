window.skymapper_app.controller 'SearchController', ['$scope', '$window',

  class SearchController

    constructor: ($scope, $window) ->
      $scope.searching = false
      $scope.submitted = false
      $scope.form = {}

      $scope.submit = (form, url) ->
        $scope.submitted = true
        if $scope[form].$valid
          params = {}
          for key, value of $scope.form
            params[key] = value unless isBlank(value)
          args = encodeQueryParams(params)
          $window.location.href = "#{url}?#{args}"

      $scope.setInput = (field, value) ->
        $scope.form[field] = value unless isBlank(value)

]