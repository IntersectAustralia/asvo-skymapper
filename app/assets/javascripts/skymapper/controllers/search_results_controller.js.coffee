window.skymapper_app.controller 'SearchResultsController', ['$scope', '$window', 'dataService',

  class SearchResultsController

    constructor: ($scope, $window, dataService) ->

      $scope.objects = undefined
      $scope.searching = false

      $scope.doSearch = (url) ->

        $scope.objects = undefined
        $scope.searching = true

        args = decodeQueryParams($window.location.search.substring(1))
        results_promise = dataService.fetchObjects(url, args)
        results_promise.then(
            (data) ->
              $scope.objects = data.objects
              flash('notice', "Query returned #{$scope.objects.length} objects.", 5000)
              $scope.searching = false
            ,
            (error) ->
              flash('error', 'There was an error fetching the results.', 5000)
              $scope.searching = false
            ,
            undefined
          )
        flash('notice', 'Fetching results...')
]