leaflet = require 'leaflet'

class Map
  TILES_BW: 'http://a.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png'
  TILES_WATERCOLOR: "http://a.tile.stamen.com/watercolor/{z}/{x}/{y}.jpg"
  BASE_TILE_OPTIONS:
    minZoom: 3
    maxZoom: 12
  MAP_OPTIONS:
    center: [52.52, 13.41]
    zoom: 6
    closePopupOnClick: false
    attributionControl: false

  constructor: ($rootscope, $scope, places) ->
    @_initMap()

    # console.log 'map ctrl', places
    # places.query ->
    #   console.log 'places done', arguments
  _initMap: ->
    grayscale = leaflet.tileLayer @TILES_BW, @BASE_TILE_OPTIONS
    watercolor = leaflet.tileLayer @TILES_WATERCOLOR, @BASE_TILE_OPTIONS

    options = @MAP_OPTIONS
    options.layers = [watercolor, grayscale]
    @map = leaflet.map 'map', options

    baseMaps =
      "Watercolor": watercolor
      "Grayscale": grayscale
    leaflet.control.layers(baseMaps, {}).addTo @map

module.exports = Map
