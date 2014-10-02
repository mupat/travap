express = require 'express'
app = express()

places = "#{__dirname}/../places"
router = new (require "#{__dirname}/router") places
app.port = process.env.PORT || 8080

#define middleware
app.use express.static "#{__dirname}/../dest"

router.init app

#start server
app.listen app.port, ->
  console.log 'started on: ', app.port
