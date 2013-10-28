window.skymapper_app.controller 'SearchController', ['$scope', '$window',

  class SearchController

    constructor: ($scope, $window) ->
      $scope.searching = false
      $scope.submitted = false
      $scope.form = {}

      $scope.submit = (form, url) ->
        $scope.submitted = true
        if $scope[form].$valid
          args = encodeQueryParams($scope.form)
          $window.location.href = "#{url}?#{args}"

]