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
              flash('notice', "Query returned #{$scope.objects.length} objects.", 8000)
              $scope.searching = false
            ,
            (error) ->
              flash('error', 'There was an error fetching the results.', 8000)
              $scope.searching = false
            ,
            undefined
          )
        flash('notice', 'Fetching results...')

      $scope.download = (url) ->
        args = decodeQueryParams($window.location.search.substring(1))

        form_arg_promise = dataService.fetchDownloadQueryArguments(url, args)

        form_arg_promise.then(
          (data) ->
            format_param = '?format=votable'

            if "CSV" == $("#download_options").val()
              format_param = '?format=csv'

            form = JST['download_query_form']({
              url: data.url.scheme + '://' + data.url.host + ':' + data.url.port + data.url.path + format_param,
              query: data.query
            })

            $('body').append(form)
            $("#downloadResults").submit()
            $("#downloadResults").remove();
            $("#downloadModal").modal('hide');
          ,
          (error) ->
            flash('error', 'There was an error downloading the results.', 8000)
            $("#downloadModal").modal('hide');
          ,
          undefined
        )
        $("#downloadModal").modal('show');

      $scope.downloadImage = (url) ->
        window.location.href = url if confirm('You are about to download a large image. Are you sure you want to continue?')
]