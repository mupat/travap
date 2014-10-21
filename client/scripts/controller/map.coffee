leaflet = require 'leaflet'

class Map
  TILES_WATERCOLOR: "http://a.tile.stamen.com/watercolor/{z}/{x}/{y}.jpg"
  BASE_TILE_OPTIONS:
    minZoom: 3
    maxZoom: 12
  MAP_OPTIONS:
    center: [52.52, 13.41]
    zoom: 6
    closePopupOnClick: false
    attributionControl: false
  MARKER_GROUP: leaflet.featureGroup()
  MARKER_CLASS: 'travap-place-marker'

  constructor: ($rootscope, @$scope, @$location, @$compile, places) ->
    $rootscope.pageTitle = 'Places' # set title attr
    @_initMap() # init map
    places.query @_initMarkers.bind(@) # init markers on the map

  _initMap: ->
    options = @MAP_OPTIONS
    options.layers = leaflet.tileLayer.grayscale @TILES_WATERCOLOR, @BASE_TILE_OPTIONS

    @map = leaflet.map 'map', options #create map
    @MARKER_GROUP.addTo @map # add feature group to map
    @map.invalidateSize()

  _initMarkers: (places) ->
    # iterater through places and add marker to the map
    places.forEach (place) =>
      icon = leaflet.angularIcon
        className: @MARKER_CLASS
        element: @_getElement(place)

      leaflet.marker(
        [place.coordinates.lat, place.coordinates.lng],
        icon: icon
      ).addTo(@MARKER_GROUP)
       .on 'click', =>
         @$location.path "#{@$location.path()}/#{place.id}"
         @$scope.$apply()

    @map.fitBounds @MARKER_GROUP.getBounds()

  _getElement: (place) ->
    compiled = @$compile """
      <travap-marker
        name='#{place.name}'
        amount='#{place.amount}'
        begin='#{place.begin}'
        end='#{place.end}'
        description='#{place.description}'
      ></travap-marker>
    """

    return compiled(@$scope)

module.exports = Map
