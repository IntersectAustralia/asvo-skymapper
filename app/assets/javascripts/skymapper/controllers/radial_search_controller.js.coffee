window.skymapper_app.controller 'RadialSearchController',

  class RadialSearchController

    constructor: ($scope, $dataService) ->

      $scope.form = {}

      $scope.peformRadialSearch = ->

        $dataService.fetchObjects($scope.form)