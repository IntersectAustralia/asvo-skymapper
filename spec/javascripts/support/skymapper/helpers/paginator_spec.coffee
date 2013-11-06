#= require skymapper/helpers/paginator

describe 'Paginator', ->

  it 'it cannot paginate if max page links undefined', ->
    paginator = new Paginator()
    paginator.init(undefined, 50)
    paginator.setItems([])
    paginator.selectPage(0)
    expect(paginator.currentPage).toEqual(undefined)
    expect(paginator.totalPages).toEqual(undefined)
    expect(paginator.pageLinks).toEqual(undefined)
    expect(paginator.pageItems).toEqual(undefined)

  it 'it cannot paginate if items per page is undefined', ->
    paginator = new Paginator()
    paginator.init(10, undefined)
    paginator.setItems([])
    paginator.selectPage(0)
    expect(paginator.currentPage).toEqual(undefined)
    expect(paginator.totalPages).toEqual(undefined)
    expect(paginator.pageLinks).toEqual(undefined)
    expect(paginator.pageItems).toEqual(undefined)

  it 'it cannot paginate if items undefined', ->
    paginator = new Paginator()
    paginator.init(10, 50)
    paginator.setItems(undefined)
    paginator.selectPage(0)
    expect(paginator.currentPage).toEqual(undefined)
    expect(paginator.totalPages).toEqual(undefined)
    expect(paginator.pageLinks).toEqual(undefined)
    expect(paginator.pageItems).toEqual(undefined)

  it 'it can paginate if items are empty', ->
    paginator = new Paginator()
    paginator.init(10, 50)
    paginator.setItems([])
    paginator.selectPage(0)
    expect(paginator.currentPage).toEqual(0)
    expect(paginator.totalPages).toEqual(0)
    expect(paginator.pageLinks).toEqual([])
    expect(paginator.pageItems).toEqual([])

  it 'it can paginate if pages less than max', ->
    paginator = new Paginator()
    paginator.init(10, 50)
    paginator.setItems([1..355])

    paginator.selectPage(0)
    expect(paginator.currentPage).toEqual(0)
    expect(paginator.totalPages).toEqual(8)
    expect(paginator.pageLinks).toEqual([0..7])
    expect(paginator.pageItems).toEqual([1..50])
    expect(paginator.isFirstPage()).toEqual(true)
    expect(paginator.isLastPage()).toEqual(false)

    paginator.selectPage(7)
    expect(paginator.currentPage).toEqual(7)
    expect(paginator.totalPages).toEqual(8)
    expect(paginator.pageLinks).toEqual([0..7])
    expect(paginator.pageItems).toEqual([351..355])
    expect(paginator.isFirstPage()).toEqual(false)
    expect(paginator.isLastPage()).toEqual(true)

    paginator.selectPage(4)
    expect(paginator.currentPage).toEqual(4)
    expect(paginator.totalPages).toEqual(8)
    expect(paginator.pageLinks).toEqual([0..7])
    expect(paginator.pageItems).toEqual([201..250])
    expect(paginator.isFirstPage()).toEqual(false)
    expect(paginator.isLastPage()).toEqual(false)

  it 'it can paginate pages more than max', ->
    paginator = new Paginator()
    paginator.init(10, 10)
    paginator.setItems([1..355])

    paginator.selectPage(0)
    expect(paginator.currentPage).toEqual(0)
    expect(paginator.totalPages).toEqual(36)
    expect(paginator.pageLinks).toEqual([0..9])
    expect(paginator.pageItems).toEqual([1..10])
    expect(paginator.isFirstPage()).toEqual(true)
    expect(paginator.isLastPage()).toEqual(false)

    paginator.selectPage(35)
    expect(paginator.currentPage).toEqual(35)
    expect(paginator.totalPages).toEqual(36)
    expect(paginator.pageLinks).toEqual([26..35])
    expect(paginator.pageItems).toEqual([351..355])
    expect(paginator.isFirstPage()).toEqual(false)
    expect(paginator.isLastPage()).toEqual(true)

    paginator.selectPage(24)
    expect(paginator.currentPage).toEqual(24)
    expect(paginator.totalPages).toEqual(36)
    expect(paginator.pageLinks).toEqual([19..28])
    expect(paginator.pageItems).toEqual([241..250])
    expect(paginator.isFirstPage()).toEqual(false)
    expect(paginator.isLastPage()).toEqual(false)

  it 'it can paginate pages with odd max', ->
    paginator = new Paginator()
    paginator.init(11, 10)
    paginator.setItems([1..355])

    paginator.selectPage(0)
    expect(paginator.currentPage).toEqual(0)
    expect(paginator.totalPages).toEqual(36)
    expect(paginator.pageLinks).toEqual([0..10])
    expect(paginator.pageItems).toEqual([1..10])
    expect(paginator.isFirstPage()).toEqual(true)
    expect(paginator.isLastPage()).toEqual(false)

    paginator.selectPage(35)
    expect(paginator.currentPage).toEqual(35)
    expect(paginator.totalPages).toEqual(36)
    expect(paginator.pageLinks).toEqual([25..35])
    expect(paginator.pageItems).toEqual([351..355])
    expect(paginator.isFirstPage()).toEqual(false)
    expect(paginator.isLastPage()).toEqual(true)

    paginator.selectPage(24)
    expect(paginator.currentPage).toEqual(24)
    expect(paginator.totalPages).toEqual(36)
    expect(paginator.pageLinks).toEqual([18..28])
    expect(paginator.pageItems).toEqual([241..250])
    expect(paginator.isFirstPage()).toEqual(false)
    expect(paginator.isLastPage()).toEqual(false)