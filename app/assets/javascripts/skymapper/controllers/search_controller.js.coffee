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
                params[key] = check_ra_and_dec(key, value)
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

      # Should move this to helpers
      $scope.requiredValid = (form) ->
        errors = $scope[form].$error
        result = true
        for key, value of errors
          if key == 'required' and errors[key]
            for key, value of errors[key]
              console.log value
              result = value.$name == 'email'
          else if key != 'email'
            result = result and not value
        return result

]