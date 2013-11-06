window.flash = (type, message, time) ->
  $('.js-flash').empty()
  $('.js-flash').append(JST['flash']({type: type, message: message}))
  if time
    timeout = ->
      $('.js-flash .alert').slideUp(500)
    setTimeout(timeout, time)