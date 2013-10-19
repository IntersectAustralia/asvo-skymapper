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
    return unless @maxPageLinks && @itemsPerPage && @items
    
    if page >= @totalPages
      page = @totalPages - 1
    else if page < 0
      page = 0

    return if page == @currentPage

    @currentPage = page
    @totalPages = Math.ceil(@items.length / @itemsPerPage)
    @pageLinks = @getPageLinks(@currentPage, @totalPages, @maxPageLinks)
    @pageItems = @items.slice(@currentPage * @itemsPerPage, (@currentPage + 1) * @itemsPerPage)

  getPageLinks: (page, total, size) ->
    min_delta = Math.ceil(size / 2)
    max_delta = size - min_delta
    min_page = Math.max(0, page - min_delta)
    max_page = Math.min(total, page + max_delta)

    if min_page == 0
      max_page = Math.min(total, min_page + size)
    else if max_page == total
      min_page = Math.max(0, max_page - size)

    start = min_page
    end = Math.max(min_page, max_page-1)
    return [] if start == end
    [start..end]

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

