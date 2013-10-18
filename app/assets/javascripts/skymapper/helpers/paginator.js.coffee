class @Paginator

  constructor: ->
    @currentPage = undefined
    @totalPages = undefined
    @pageLinks = undefined
    @maxPageLinks = undefined
    @itemsPerPage = undefined
    @items = undefined
    @pageItems = undefined

  init: (@maxPageLinks, @itemsPerPage) ->

  setItems: (@items) ->
    
  selectPage: (page) ->
    return unless @items
    return if page >= @totalPages
    return if page < 0
    return if page == @currentPage

    @currentPage = page
    @totalPages = Math.ceil(@items.length / @itemsPerPage)
    @pageLinks = @getPageLinks(@currentPage, @totalPages, @maxPageLinks)
    @pageItems = @items.slice(@currentPage * @itemsPerPage, (@currentPage + 1) * @itemsPerPage)

  getPageLinks: (page, total, size) ->
    links = []

    min_page = Math.max(0, page - size)
    max_page = Math.min(total, page + size)

    if min_page == 0
      max_page = Math.min(total, min_page + size * 2)
    else if max_page == total
      min_page = Math.max(0, max_page - size * 2)

    for i in [min_page..max_page-1]
      links.push(i)
    links

  isFirstPage: ->
    @currentPage == 0

  isLastPage: ->
    @currentPage == @totalPages - 1

  firstPage: ->
    @selectPage(0) unless @isFirstPage()

  previousPage: ->
    @selectPage(@currentPage - 1) unless @isFirstPage()

  nextPage: ->
    @selectPage(@currentPage + 1) unless @isLastPage()

  lastPage: ->
    @selectPage(@totalPages - 1) unless @isLastPage()

