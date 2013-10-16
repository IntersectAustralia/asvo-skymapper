window.skymapper_app.controller 'RadialSearchController', ['$scope', '$dataService',

  class RadialSearchController

    @RADIAL_SEARCH_URL = 'search/radial'

    constructor: ($scope, $dataService) ->

      $scope.form = {}
      $scope.objects = undefined
      $scope.submitted = false

      $scope.peformRadialSearch = ->

        $scope.submitted = true

        if $scope.radial_search_form.$valid

          $scope.objects = undefined
          $scope.$parent.searching = true
          results_promise = $dataService.fetchObjects(RadialSearchController.RADIAL_SEARCH_URL, $scope.form)

          results_promise.then(
            (objects) ->
              $scope.objects = objects
              flash('notice', 'Completed Search')
              $scope.$parent.searching = false
            ,
            (error) ->
              flash('error', error)
              $scope.$parent.searching = false
            ,
            undefined
          )

]