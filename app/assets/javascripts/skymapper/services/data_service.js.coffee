angular.module('SkyMapper.DataService', []).service 'dataService', ['$http', '$q',

  class DataService

    constructor: (@$http, @$q) ->

    generateURL: (url, args) ->
      "#{url}?#{encodeQueryParams({query:args})}"

    fetchObjects: (url, args) ->
      deferred_results = @$q.defer()

      @$http.get(@generateURL(url, args))

        .success (data) ->
          #console.log("success: #{data}")

          deferred_results.resolve(data)

        .error (data) ->
          #console.log("error: #{data}")

          deferred_results.reject(data.error)

      deferred_results.promise
]