class Gallery
  constructor: ($rootscope, $scope, $routeParams, $location, places) ->
    console.log 'gallery ctrl', $routeParams
    $scope.item = places.get id: $routeParams.id, ->
      console.log 'done gallery', arguments


module.exports = Gallery
