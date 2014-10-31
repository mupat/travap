document = window.document
angular = require 'angular'

class Gallery
  CSS_TRANSITION: 'transition'
  CSS_TRANSITION_TIME: 300
  DEFAULT: 
    open: -1
    play: undefined
    lastPlayItem: -1
    openImg: ''

  constructor: (@$rootscope, @$scope, $routeParams, @$location, @$interval, @$timeout, @places) ->
    @view = document.querySelector '.gallery-view'

    @_initScope()
    @_init $routeParams.id    

  _init: (place) ->
    @$scope.item = @places.get id: place, =>
      angular.extend @$scope.item, @DEFAULT      
      @$rootscope.pageTitle = "Place - #{@$scope.item.name}" # set title attr

  _initScope: ->
    @$scope.back = @_back.bind @
    @$scope.showPrevious = @_move.bind @, 'prev'
    @$scope.showNext = @_move.bind @, 'next'
    @$scope.playStop = @_playStop.bind @
    @$scope.open = @_open.bind @
    @$scope.close = @_close.bind @

  _back: ->
    @$location.path "/places" # for going back to map, change location

  _move: (direction) ->
    item = @$scope.item
    return if item.open is -1 

    length = item.images.length - 1
    start = 0

    if direction is 'next'
      newIndex = if item.open is length then start else item.open += 1

    if direction is 'prev'
      newIndex = if item.open is start then length else item.open -= 1

    item.open = newIndex
    @$scope.item.openImg = @$scope.item.images[@$scope.item.open]
    @_addPosition item.open

  _playStop: ->
    if $scope.item.play?
      $interval.cancel $scope.item.play
      $scope.lastPlayItem = $scope.item.fullscreen
      $scope.item.play = undefined
      $scope.item.fullscreen = -1
      return

    $scope.item.fullscreen = $scope.lastPlayItem || 0
    $scope.item.play = $interval ( -> $scope.showNext() ), 2000

  _open: (index) ->
    # add image to fullscreen layer
    @$scope.item.openImg = @$scope.item.images[index]
    @_addPosition index

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

  _addPosition: (index) ->
    image = document.getElementById 'image-' + index #get actual image
    rect = image.getBoundingClientRect() # get bound box of image

    # set style according to the image
    @view.style.top = "#{rect.top}px"
    @view.style.left = "#{rect.left}px"
    @view.style.width = "#{image.offsetWidth}px"
    @view.style.height = "#{image.offsetHeight}px"

module.exports = Gallery
