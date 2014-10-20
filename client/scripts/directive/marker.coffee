link = (scope, element, attrs) ->
  scope.infos =
    name: attrs.name
    description: attrs.description
    amount: attrs.amount
    begin: attrs.begin
    end: attrs.end

  return element

module.exports = ->
  options =
    restrict: "E"
    replace: true
    link: link
    scope: {}
    templateUrl: 'templates/marker.html'
    
  return options
