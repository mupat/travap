fs = require 'fs'
path = require 'path'
Places = require "#{__dirname}/places"

class Router
  constructor: (directory) ->
    #check if directory exists
    @_directoryExists directory, (err) =>
      throw err if err
      @baseDirectory = directory
      @places = new Places @baseDirectory

  init: (app) ->
    #define routes
    app.get '/places', @_all.bind(@)
    app.get '/places/:id', @_one.bind(@)
    app.get "/images/:place/:file", @_image.bind(@)

  _image: (req, res, next) ->
    place = req.params.place
    file = req.params.file
    resolved = path.resolve __dirname, "#{@baseDirectory}/#{place}/#{file}"
    res.sendFile resolved

  _all: (req, res, next) =>
    @_directoryExists (err) =>
      return next err if err

      @places.getAllInfos (err, places) ->
        return next err if err
        res.json places

  _one: (req, res, next) =>
    name = req.params.id
    @_directoryExists "#{@baseDirectory}/#{name}", (err) =>
      return next err if err

      host = req.header['Host']
      @places.getAllImages name, host, (err, images) ->
        return next err if err
        res.json images

  _directoryExists: (directory, done) ->
    # set directory to baseDirectory, if no one special is provided
    unless typeof directory is 'string'
      done = directory
      directory = @baseDirectory 

    fs.exists directory, (exists) ->
      error = if exists then undefined else new Error "#{directory} doesnt exists"
      done error

module.exports = Router