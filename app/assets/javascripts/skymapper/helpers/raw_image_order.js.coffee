compare_filters = (filter1, filter2) ->
  return false if isBlank(filter1)
  return false if isBlank(filter2)

  filters = ['u', 'v', 'g', 'r', 'i', 'z']
  filters.indexOf(filter1.toLowerCase()) - filters.indexOf(filter2.toLowerCase())

compare_numbers = (num1, num2) ->
  return false unless isNumber(num1)
  return false unless isNumber(num2)
  Number(num1) - Number(num2)

@rawImageOrder = (fields, obj1, obj2) ->
  # assume the order of the fields to be ra, dec, filter, survey and date

  order = compare_numbers(obj1[fields[0]], obj2[fields[0]])
  #console.log('ra', order)
  return -1 if order < 0
  return 1 if order > 0

  order = compare_numbers(obj1[fields[1]], obj2[fields[1]])
  #console.log('dec', order)
  return -1 if order < 0
  return 1 if order > 0

  order = compare_filters(obj1[fields[2]], obj2[fields[2]])
  #console.log('filter', order)
  return -1 if order < 0
  return 1 if order > 0

  order = compare_numbers(obj1[fields[4]], obj2[fields[4]])
  #console.log('date', order)
  return -1 if order < 0
  return 1 if order > 0

  # do a final sort on object_id to provide consistent ordering of test data that doesn't have filters or dates
  order = compare_numbers(obj1[fields[6]], obj2[fields[6]])

  return order