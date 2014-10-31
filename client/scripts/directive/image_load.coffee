link = (scope, el, attrs) ->
  el.bind 'load', ->
    scope.$apply attrs.travapImageonload
  
module.exports = ->
  options =
    restrict: 'A'
    link: link

  return options