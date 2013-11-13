angular.module('SkyMapper.DataService', []).service 'dataService', ['$http', '$q',

  class DataService

    constructor: (@$http, @$q) ->

    generateURL: (url, args) ->
      return url unless args

      "#{url}?#{encodeQueryParams({query:args})}"

    fetch: (dataUrl, args, progressUrl = undefined) ->
      parent = @

      deferred_results = @$q.defer()

      results_promise = @get(dataUrl, args)

      results_promise.then(
        (data) ->
          deferred_results.resolve(data)
          parent.stopProgressPoll()
        ,
        (error) ->
          deferred_results.reject(error)
          parent.stopProgressPoll()
      )

      @startProgressPoll(progressUrl, deferred_results) if progressUrl

      deferred_results.promise

    get: (url, args = undefined) ->
      deferred_results = @$q.defer()

      @$http.get(@generateURL(url, args))

        .success (data) ->
          deferred_results.resolve(data)

        .error (data) ->
          deferred_results.reject(data)

      deferred_results.promise

    post: (url, formData) ->
      deferred_results = @$q.defer()

      @$http.post(url, formData)

      .success (data) ->
          deferred_results.resolve(data)

      .error (data) ->
          deferred_results.reject(data)

      deferred_results.promise

    startProgressPoll: (url, deferred_results) ->
      @updateProgress(url, deferred_results)

    stopProgressPoll: ->
      clearTimeout(@pollId) if @pollId

    updateProgress: (url, deferred_results) ->
      parent = @

      @pollId = setTimeout(
        ->
          results_promise = parent.get(url)

          results_promise.then(
            (data) ->

              deferred_results.notify(data)

              parent.updateProgress(url, deferred_results)
            (error) ->

              parent.updateProgress(url, deferred_results)
          )
      ,
        1000
      )

]