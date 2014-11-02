document = window.document
angular = require 'angular'

class Gallery
  CSS_TRANSITION: 'transition'
  CSS_TRANSITION_TIME: 300
  DEFAULT: 
    open: -1
    play: undefined
    lastPlayItem: undefined
    openImg: ''
    loaded: false
    limit: 10000
    fullscreen: false

  constructor: (@$rootscope, @$scope, $routeParams, @$location, @$interval, @$timeout, @places) ->
    @_reset()
    @_initScope()
    @_init $routeParams.id    

  _init: (place) ->
    @$scope.place = @places.get id: place, =>
      @$rootscope.pageTitle = "Place - #{@$scope.item.name}" # set title attr

  _reset: ->
    @view = document.querySelector '.gallery-view'
    @imagesLoaded = 0
    @$scope.item = @DEFAULT
    @$scope.place = {}

  _initScope: ->
    @$scope.back = @_back.bind @
    @$scope.showPrevious = @_move.bind @, 'prev'
    @$scope.showNext = @_move.bind @, 'next'
    @$scope.playStop = @_playStop.bind @
    @$scope.open = @_open.bind @
    @$scope.close = @_close.bind @
    @$scope.onLoad = @_onload.bind @
    @$scope.toggleFullscreen = @_toggleFullscreen.bind @

    # listen for changes and apply them to the scope
    document.addEventListener screenfull.raw.fullscreenchange, =>
      @$scope.$apply =>
        @$scope.item.fullscreen = screenfull.isFullscreen

   _toggleFullscreen: ->
      screenfull.toggle();
      @$scope.item.fullscreen = !@$scope.item.fullscreen 

  _onload: (index) =>
    @imagesLoaded++
    if @imagesLoaded is @$scope.place.images.length
      @$scope.item.loaded = true
      for image in @$scope.place.images
        do (image) =>
          @$timeout ( => image.loaded = true ), Math.random() * (500 - 100) + 100

  _back: ->
    @$location.path "/places" # for going back to map, change location

  _move: (direction) ->
    item = @$scope.item
    place = @$scope.place
    return if item.open is -1 

    length = place.images.length - 1
    start = 0

    if direction is 'next'
      newIndex = if item.open is length then start else item.open += 1

    if direction is 'prev'
      newIndex = if item.open is start then length else item.open -= 1

    # item.open = newIndex
    # item.openImg = place.images[item.open]
    # @_addPosition item.open
    @_open newIndex

  _playStop: ->
    item = @$scope.item
    if item.play?
      @$interval.cancel item.play
      item.lastPlayItem = item.open
      item.play = undefined
      @$scope.close()
      return

    # item.open = item.lastPlayItem or 0
    @$scope.open item.lastPlayItem || 0
    item.play = @$interval ( => @$scope.showNext() ), 2000

  _open: (index) ->
    image = document.getElementById 'image-' + index #get actual image
    # add image to fullscreen layer
    @$scope.item.openImg = image.src
    @_addPosition image

    show = ->
      @view.classList.add @CSS_TRANSITION
      @$scope.item.open = index

    @$timeout show.bind(@), @CSS_TRANSITION_TIME

  _close: ->
    @$scope.item.open = -1

    remove = ->
      @view.classList.remove @CSS_TRANSITION
      @view.style.top = ""
      @view.style.left = ""
      @view.style.width = ""
      @view.style.height = ""

    @$timeout remove.bind(@), @CSS_TRANSITION_TIME

  _addPosition: (image) ->    
    rect = image.getBoundingClientRect() # get bound box of image

    # set style according to the image
    @view.style.top = "#{rect.top}px"
    @view.style.left = "#{rect.left}px"
    @view.style.width = "#{image.offsetWidth}px"
    @view.style.height = "#{image.offsetHeight}px"

module.exports = Gallery
