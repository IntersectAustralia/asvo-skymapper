window.skymapper_app.filter 'min', ->

   (input, min_value) ->
      return min_value unless input
      return min_value if input < min_value

      input
