window.skymapper_app.controller 'SearchController', ['$scope', '$window',

  class SearchController

    constructor: ($scope, $window) ->
      $scope.searching = false
      $scope.submitted = false
      $scope.form = {}

      $scope.submit = (form, url) ->
        $scope.submitted = true
        console.log(form)
        console.log($scope[form])
        if $scope[form].$valid
          args = jQuery.param($scope.form)
          $window.location.href = "#{url}?#{args}"

]