toPages = (page, total, size) ->
  pages = []

  min_page = Math.max(0, page - size)
  max_page = Math.min(total, page + size)

  if min_page == 0
    max_page = Math.min(total, min_page + size * 2)
  else if max_page == total
    min_page = Math.max(0, max_page - size * 2)

  for i in [min_page..max_page-1]
    pages.push(i)
  pages

window.skymapper_app.controller 'PaginationController', ['$scope',

  class PaginationController

    constructor: ($scope) ->

      $scope.pagination = {
        previousLinkDisabled: undefined,
        nextLinkDisabled: undefined,

        currentPage: undefined,
        totalPages: undefined,
        pages: undefined,
        maxSize: 10,
        itemsPerPage: 50,
        items: undefined,
        pageItems: undefined
      }

      $scope.$watch 'objects', ->
        return unless $scope.objects

        $scope.pagination.items = $scope.objects
        $scope.onPage(0)

      $scope.onPage = (page) ->
        p = $scope.pagination

        return if page >= p.totalPages
        return if page < 0
        return if p.currentPage == page

        p.currentPage = page
        p.totalPages = Math.ceil(p.items.length / p.itemsPerPage)
        p.pages = toPages(p.currentPage, p.totalPages, p.maxSize)
        p.pageItems = p.items.slice(p.currentPage * p.itemsPerPage, (p.currentPage + 1) * p.itemsPerPage)

        p.previousLinkDisabled = p.currentPage == 0
        p.nextLinkDisabled = p.currentPage == p.totalPages - 1

      $scope.onFirst = ->
        $scope.onPage(0) unless $scope.pagination.previousLinkDisabled

      $scope.onPrevious = ->
        $scope.onPage($scope.pagination.currentPage - 1) unless $scope.pagination.previousLinkDisabled

      $scope.onNext = ->
        $scope.onPage($scope.pagination.currentPage + 1) unless $scope.pagination.nextLinkDisabled

      $scope.onLast = ->
        $scope.onPage($scope.pagination.totalPages - 1) unless $scope.pagination.nextLinkDisabled
]