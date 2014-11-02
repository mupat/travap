exifRotate = require 'exif-rotate'

link = (scope, el, attrs) ->
  rotate attrs.$$element[0], attrs.travapSrc, Number(attrs.travapOrientation), ->
    scope.$apply attrs.travapImageonload

rotate = (img, href, orientation, done) ->
  imgOld = new Image
  imgOld.src = href

  imgOld.onload = ->
    uri = exifRotate imgOld, orientation
    img.src = uri
    img.onload = done

module.exports = ->
  options =
    restrict: 'A'
    link: link

  return options