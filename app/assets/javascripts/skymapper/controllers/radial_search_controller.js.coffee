window.skymapper_app.controller 'RadialSearchController', ['$scope', '$dataService',

  class RadialSearchController

    @RADIAL_SEARCH_URL = 'search/radial'

    constructor: ($scope, $dataService) ->

      $scope.submitted = false
      $scope.form = {}
      $scope.objects = []

      $scope.peformRadialSearch = ->
        $scope.submitted = true

        if $scope.radial_search_form.$valid
          results_promise = $dataService.fetchObjects(RadialSearchController.RADIAL_SEARCH_URL, $scope.form)

          results_promise.then(
            (objects) ->
              $scope.objects = objects
              flash('notice', 'Completed Search')
            ,
            (error) ->
              flash('error', error)
            ,
            undefined
          )

]