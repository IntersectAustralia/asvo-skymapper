window.skymapper_app.filter 'isRa', ->

  (input, appendix, default_value) ->
    deg = ra_to_deg(input)
    if deg
      return appendix + deg
    else
      return default_value
