Places = require "./places"

services =
  places: [
    '$resource'
    Places
  ]

module.exports = services
