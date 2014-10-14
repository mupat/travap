router = ($routeProvider) ->
  @MAP =
    templateUrl: 'templates/map.html'
    controller: 'MapCtrl'

  @GALLERY =
    templateUrl: 'templates/gallery.html'
    controller: 'GalleryCtrl'

  $routeProvider.when '/places', @MAP
  $routeProvider.when '/places/:id', @GALLERY
  $routeProvider.otherwise redirectTo: '/places'

module.exports = [
  '$routeProvider'
  router
]
