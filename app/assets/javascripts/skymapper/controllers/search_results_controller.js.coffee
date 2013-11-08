window.skymapper_app.controller 'SearchResultsController', ['$scope', '$window', 'dataService',

  class SearchResultsController

    constructor: ($scope, $window, dataService) ->

      $scope.objects = undefined

      $scope.doSearch = (url) ->

        $scope.objects = undefined

        args = decodeQueryParams($window.location.search.substring(1))
        results_promise = dataService.get(url, args)
        results_promise.then(
            (data) ->
              $scope.objects = data.objects
              flash('notice', "Query returned #{$scope.objects.length} objects.", 10000)
            ,
            (error) ->
              flash('error', 'There was an error fetching the results.', 10000)
            ,
            undefined
          )
        flash('notice', 'Fetching results...')

      $scope.doDownload = (url) ->
        args = decodeQueryParams($window.location.search.substring(1))
        form_arg_promise = dataService.get(url, args)

        form_arg_promise.then(
          (data) ->
            $scope.postDownloadForm(data.url, data.query, $("#download_options").val())
            $("#downloadModal").modal('hide')
          ,
          (error) ->
            flash('error', 'There was an error downloading the results.', 8000)
            $("#downloadModal").modal('hide')
          ,
          undefined
        )
        $("#downloadModal").modal('show')

      $scope.downloadImage = (url) ->
        window.location.href = url if confirm('You are about to download a large image. Are you sure you want to continue?')

      $scope.selectObject = (obj) ->
        $scope.selectedObject = obj

      $scope.postDownloadForm = (url, query, format) ->
        flash('notice', 'Fetching results...', 10000)

        if "CSV" == format
          format_param = '?format=csv'
        else
          format_param = '?format=votable'

        form = JST['download_query_form']({
          url: url + format_param,
          query: query
        })

        $('body').append(form)
        $("#downloadResults").submit()
        $("#downloadResults").remove()

      $scope.downloadResults = (url, format, elem) ->
        query = $("##{elem}").text()
        $scope.postDownloadForm(url, query, format)

]