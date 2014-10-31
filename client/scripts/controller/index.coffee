MapCtrl = require "./map"
GalleryCtrl = require "./gallery"

controllers =
  MapCtrl: [
    '$rootScope'
    '$scope'
    '$location'
    '$compile'
    'places'
    MapCtrl
  ]
  GalleryCtrl: [
    '$rootScope'
    '$scope'
    '$routeParams'
    '$location'
    '$interval'
    '$timeout'
    'places'
    GalleryCtrl
  ]

module.exports= controllers
