places = ($resource) ->
  # res = $resource '/places/:id', {id: "@id"}, {query: {method: 'GET', isArray:true}}
  res = $resource '/places/:id'
  console.log 'res', res
  return res

module.exports = places
