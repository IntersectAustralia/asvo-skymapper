FLASH_TIMEOUT = 5000

window.flash = (type, message) ->
  $('.flash').empty()
  $('.flash').append(JST['flash']({type: type, message: message}))
  $('.flash .alert').delay(FLASH_TIMEOUT).fadeOut()