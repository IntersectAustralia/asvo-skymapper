window.skymapper_app.controller 'SearchController', ['$scope', '$window',

  class SearchController

    constructor: ($scope, $window) ->
      $scope.submitted = false
      $scope.form = {}

      $scope.fetchResults = (form, url) ->
        if $scope.form.async
          $('#asyncJob').modal('show')
          return # need this line or Angular freaks out
        else
          $scope.submitted = true
          if $scope[form].$valid
            params = {}
            for key, value of $scope.form
              unless isBlank(value)
                if key.indexOf("_max") > -1 or key.indexOf("_min")  > -1
                  params[key] = value
                else
                  params[key] = clean(value)
            args = encodeQueryParams(params)
            $window.location.href = "#{url}?#{args}"

      $scope.submit = (form, event) ->
        event.preventDefault()
        false
        # $scope.submitted = true
        # event.preventDefault() unless $scope[form].$valid

      $scope.setInput = (field, value) ->
        $scope.form[field] = value unless isBlank(value)

]