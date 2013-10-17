window.flash = (type, message, time) ->
  $('.flash').empty()
  $('.flash').append(JST['flash']({type: type, message: message}))
  $('.flash .alert').delay(time).fadeOut() unless time == undefined