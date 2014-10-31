marker = require "./marker"
imageLoader = require "./image_load"

Directives =
  "travapMarker": [
    marker
  ]
  "travapImageonload": [
    imageLoader
  ]

module.exports = Directives
