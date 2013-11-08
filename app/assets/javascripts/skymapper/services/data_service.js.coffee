angular.module('SkyMapper.DataService', []).service 'dataService', ['$http', '$q',

  class DataService

    constructor: (@$http, @$q) ->

    generateURL: (url, args) ->
      "#{url}?#{encodeQueryParams({query:args})}"

    get: (url, args) ->
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

]