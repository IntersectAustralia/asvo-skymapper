window.skymapper_app.controller 'SearchController', ['$scope', '$window',

  class SearchController

    constructor: ($scope, $window) ->
      $scope.submitted = false
      $scope.form = {}

      $scope.fetchResults = (form, url, method='get') ->
        if $scope.form.async and $scope.requiredValid(form)
          $($scope.modal_id).modal('show')
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
            if method == 'post'
              alert('ding')
              return
            else
              args = encodeQueryParams(params)
              $window.location.href = "#{url}?#{args}"


      $scope.submit = (form, event) ->
        $scope.submitted = true
        event.preventDefault() unless $scope[form].$valid

      $scope.setInput = (field, value) ->
        $scope.form[field] = value unless isBlank(value)

      $scope.init = (modal_id) ->
        $scope.modal_id = modal_id

      $scope.requiredValid = (form) ->
        errors = $scope[form].$error
        Object.keys(errors).length == 1 and errors.required and errors.required.length == 1 and errors.required[0].$name == 'email'
       


]