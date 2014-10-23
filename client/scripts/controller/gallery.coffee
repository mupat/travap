class Gallery
  constructor: ($rootscope, $scope, $routeParams, $location, $interval, places) ->
    place = $routeParams.id
    $scope.item = places.get id: place, ->
      $scope.item.fullscreen = -1
      $scope.item.play = undefined
      $scope.item.lastPlayItem = -1
      $rootscope.pageTitle = "Place - #{$scope.item.name}" # set title attr

    $scope.back = ->
      $location.path "/places"

    $scope.showPrevious = ->
      return if $scope.item.fullscreen is -1

      if $scope.item.fullscreen is 0
        $scope.item.fullscreen = $scope.item.images.length - 1
      else
        $scope.item.fullscreen--

    $scope.showNext = ->
      console.log 'next'
      return if $scope.item.fullscreen is -1

      if $scope.item.fullscreen is $scope.item.images.length - 1
        $scope.item.fullscreen = 0
      else
        $scope.item.fullscreen++

    $scope.playStop = ->
      if $scope.item.play?
        $interval.cancel $scope.item.play
        $scope.lastPlayItem = $scope.item.fullscreen
        $scope.item.play = undefined
        $scope.item.fullscreen = -1
        return

      $scope.item.fullscreen = $scope.lastPlayItem || 0
      $scope.item.play = $interval ( -> $scope.showNext() ), 2000

module.exports = Gallery
