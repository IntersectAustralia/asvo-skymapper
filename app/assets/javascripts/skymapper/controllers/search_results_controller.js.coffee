window.skymapper_app.controller 'SearchResultsController', ['$scope', '$window', 'dataService',

  class SearchResultsController

    constructor: ($scope, $window, dataService) ->

      $scope.objects = undefined

      $scope.doSearch = (url, progressUrl = undefined) ->

        $scope.objects = undefined

        args = decodeQueryParams($window.location.search.substring(1))
        results_promise = dataService.fetch(url, args, progressUrl)
        results_promise.then(
            (data) ->
              $scope.objects = data.objects
              flash('notice', "Query returned #{$scope.objects.length} objects.", 10000)
              $('#results-count').text("Query returned #{$scope.objects.length} objects.")
              if $scope.objects.length == 1000
                $('#truncate-warn').removeAttr('hidden')
            ,
            (error) ->
              if (error.error != null)
                flash('error', error.error, 10000)
              else
                flash('error', 'There was an error fetching the results.', 10000)
            ,
            (progress) ->
              flash('notice', progress.message)
          )
        flash('notice', 'Fetching results...')
        return

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
        )
        $("#downloadModal").modal('show')
        return

      $scope.warnImage = (url)->
        $scope.currentImage = url
        $('#imageWarnModal').modal('show')
        return

      $scope.downloadImage = ->
        $('#imageWarnModal').modal('hide')
        window.location.href = $scope.currentImage if $scope.currentImage

      $scope.selectObject = (obj) ->
        $scope.selectedObject = obj

      $scope.postDownloadForm = (url, query, format) ->
        flash('notice', 'Please wait...', 10000)

        if "CSV" == format
          format_param = '?format=csv'
          target = undefined
        else
          format_param = '?format=votable'
          target = '_blank'

        form = JST['download_query_form']({
          url: url + format_param,
          query: query,
          target: target
        })

        $('body').append(form)
        $("#downloadResults").submit()
        $("#downloadResults").remove()
        return

      $scope.downloadResults = (url) ->
        args = decodeQueryParams($window.location.search.substring(1))
        results_promise = dataService.get(url, args)
        results_promise.then(
          (data) ->
            $scope.postDownloadForm(data['url'], data['query'], data['type'])
          ,
          (error) ->
            flash('error', error.error, 1000)
        )
        return
]