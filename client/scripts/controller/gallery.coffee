document = window.document
angular = require 'angular'

class Gallery
  CSS_TRANSITION: 'transition'
  CSS_TRANSITION_TIME: 300
  DEFAULT: 
    open: -1
    play: undefined
    lastPlayItem: undefined
    openImage:
      src: ''
      direction: undefined
      out: false
      in: false
      transition: undefined
      prepare: false
    loaded: false
    limit: 10000
    fullscreen: false
    intervals: [2, 3, 5]
    interval: 2
    hideHUD: false

  constructor: (@$rootscope, @$scope, $routeParams, @$location, @$interval, @$timeout, @places) ->
    @_reset()
    @_initScope()
    @_init $routeParams.id    

  _init: (place) ->
    @$scope.place = @places.get id: place, =>
      @$rootscope.pageTitle = "Place - #{@$scope.place.name}" # set title attr

  _reset: ->
    @view = document.querySelector '.gallery-view'
    @body = document.body
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
    if screenfull.enabled
      document.addEventListener screenfull.raw.fullscreenchange, =>
        @$scope.$apply =>
          @$scope.item.fullscreen = screenfull.isFullscreen

   _toggleFullscreen: ->
    return unless screenfull.enabled
    screenfull.toggle();
    @$scope.item.fullscreen = !@$scope.item.fullscreen
    @$scope.item.hideHUD = false

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

    @$scope.item.openImage.direction = direction
    @_applyTransition newIndex

  _applyTransition: (index, transition='scaleMove') ->
    # make sure we have a out transition
    @$scope.item.openImage.out = true
    @$scope.item.openImage.transition = transition

    # make sure we have a in transition and remove after finishing
    applyEnd = =>
      @$scope.item.openImage.prepare = false
      @$scope.item.openImage.in = true

      @$timeout ( => @$scope.item.openImage.in = false ), 200

    # make sure we have a time between out and in transition to move the image to the desired start point
    applyBetween = => 
      @$scope.item.openImage.out = false
      @_open index # apply Image
      @$scope.item.openImage.prepare = true

      @$timeout applyEnd, 50

    @$timeout applyBetween, 400 #wait a bit and call between step

  _playStop: ->
    if @$scope.item.play?
      @_stop()
      @$scope.close()
      return

    @$scope.item.open = @$scope.item.lastPlayItem or 0
    @_start()

  _start: ->
    selectedInterval = @$scope.item.interval
    run = ->
      # check if interval changed, so we need to restart the interval
      if @$scope.item.interval isnt selectedInterval
        @_stop()
        @_start()
      else
        @$scope.item.showInterval = false
        @$scope.showNext()
        @$timeout ( => @$scope.item.showInterval = true ), 650

    @$scope.item.play = @$interval run.bind(@, selectedInterval), @$scope.item.interval * 1000 + 650
    run.call @, selectedInterval

    @_removeHUD()
    @body.onmousemove = =>
      @$scope.$apply =>
        @$scope.item.hideHUD = false
      @$timeout.cancel @hudTimeout
      @_removeHUD()

  _stop: ->
    @$interval.cancel @$scope.item.play
    @$scope.item.lastPlayItem = @$scope.item.open
    @$scope.item.play = undefined
    @$scope.item.showInterval = false
    @body.onmousemove = null
    @$scope.item.hideHUD = false
    @$timeout.cancel @hudTimeout

  _removeHUD: ->
    @hudTimeout = @$timeout ( => @$scope.item.hideHUD = true ), 3000

  _open: (index) ->
    image = document.getElementById 'image-' + index #get actual image
    # add image to fullscreen layer
    @$scope.item.openImage.src = image.src
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
