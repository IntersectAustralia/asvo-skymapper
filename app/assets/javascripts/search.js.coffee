$ ->
  manageTabs()

manageTabs = ->
  tab = $('#search-tabs span').text().trim()
  if tab
    $("#search-tabs li a[href='#tab-#{tab}']").tab('show')
  else
    $('#search-tabs a:first').tab('show')