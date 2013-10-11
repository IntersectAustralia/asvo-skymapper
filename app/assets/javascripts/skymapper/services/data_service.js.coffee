angular.module('SkyMapper.DataService', []).service '$dataService',

  class DataService

    @RADIAL_SEARCH_URL = 'search/radial'

    constructor: (@$http) ->

    generateURL: (url, args) ->
      url += '?'
      for key, value of args
        url += "#{key}=#{value}&"
      url

    fetchObjects: (args) ->

      results = {
        completed: false,
        success: false,
        objects: []
      }

      @$http.get(@generateURL(DataService.RADIAL_SEARCH_URL, args))

        .success (objects) ->

          results.complete = true
          results.success = true
          results.objects = objects

        .error ->

          results.complete = true
          results.success = false

      results