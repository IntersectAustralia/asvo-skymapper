window.skymapper_app.filter 'isDec', ->

  (input, appendix, default_value) ->
    deg = dec_to_deg(input)
    if deg
      return appendix + deg
    else
      return default_value
