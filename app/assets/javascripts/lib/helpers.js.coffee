@showWarning = (message) ->
	showMessage(message, 'warning')

@showNotification = (message) ->
	showMessage(message, null);

@showMessage = (message, classToUse) ->
	options = { message: message }
	if (classToUse != null)
    options.useClass = classToUse
	$.bar(options)

@decodeQueryParams = (query) ->
  q = query.split('&');
  args = {};

  n = q.length - 1
  for i in [0..n]
    pair = q[i].split('=');
    args[decodeURIComponent(pair[0])] = decodeURIComponent(pair[1])

  args

@encodeQueryParams = (params) ->
  jQuery.param(params).replace(/\+/g, '%20')

@clean = (value) ->
  value = value.replace(/\s+/g, '') if typeof value == 'string'
  value = value.replace(/^\+/g, '') if typeof value == 'string'
  value

@isBlank = (value) ->
  return true if value == undefined
  return true if @clean(value) == ''
  false

@isNumber = (value) ->
  !isNaN(Number(clean(value)))

@ra_to_deg = (value) ->
  format = "^[+]?\\d*(\\.\\d{1,6})?$"
  degreeFormatValidator = new RegexFormatValidator(format)
  if degreeFormatValidator.validate(value)
    return value
  hourFormat = "^([0-2][0-9])[:\\s]?([0-6][0-9])[:\\s]?([0-6][0-9])(.[0-9]{1,5})?$"
  values = value.match(hourFormat)
  if values != null
    return (parseFloat(values[1]) + parseFloat(values[2])/60 + parseFloat(values[3])/3600)/24 * 360
  return null

@dec_to_deg = (value) ->
  format = "^[+-]?\\d*(\\.\\d{1,6})?$"
  degreeFormatValidator = new RegexFormatValidator(format)
  if degreeFormatValidator.validate(value)
    return value
  decFormat = "^([+-]?[0-9][0-9])[:\\s]?([0-6][0-9])[:\\s]?([0-6][0-9])(.[0-9]{1,5})?$"
  values = value.match(decFormat)
  if values != null
    negative = 1
    if parseFloat(values[1]) < 0
      negative = -1
    return (Math.abs(parseFloat(values[1])) + parseFloat(values[2])/60 + parseFloat(values[3])/3600)*negative
  return null
