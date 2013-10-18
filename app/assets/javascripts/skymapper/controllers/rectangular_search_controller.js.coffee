window.skymapper_app.controller 'RectangularSearchController', ['$scope',

  class RectangularSearchController

    constructor: ($scope) ->

      $scope.ra_min_value = ->
        return $scope.$parent.form.ra_min if $scope.$parent.form.ra_min
        0

      $scope.dec_min_value = ->
        return $scope.$parent.form.dec_min if $scope.$parent.form.dec_min
        -90
]