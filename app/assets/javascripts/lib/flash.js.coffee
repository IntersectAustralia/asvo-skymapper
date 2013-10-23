window.flash = (type, message, time) ->
  $('.js-flash').empty()
  $('.js-flash').append(JST['flash']({type: type, message: message}))
  $('.js-flash .alert').delay(time).fadeOut() unless time == undefined