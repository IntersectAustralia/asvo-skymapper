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

@clean = (value) ->
  value = value.replace(/\s+/g, '') if typeof value == 'string'
  value

@isBlank = (value) ->
  return true if value == undefined
  return true if @clean(value) == ''
  false

@isNumber = (value) ->
  !isNaN(Number(clean(value)))