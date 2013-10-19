window.skymapper_app.directive 'pagination', ->

  {
    restrict: 'E',
    scope: true,
    controller: ($scope) ->
      $scope.pagination = new Paginator()
    link: (scope, elem, attr, ctrl) ->
      scope.pagination.init(attr.maxPageLinks, attr.itemsPerPage)
      scope.$watch attr.items, ->
        scope.pagination.setItems(scope[attr.items])
        scope.pagination.selectPage(0)
  }