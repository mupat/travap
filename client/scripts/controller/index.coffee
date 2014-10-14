MapCtrl = require "./map"
GalleryCtrl = require "./gallery"

controllers =
  MapCtrl: [
    '$rootScope'
    '$scope'
    'places'
    MapCtrl
  ]
  GalleryCtrl: [
    '$rootScope'
    '$scope'
    '$routeParams'
    'places'
    GalleryCtrl
  ]

module.exports= controllers
