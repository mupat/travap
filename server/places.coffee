fs = require 'fs'
async = require 'async'

class Places
  constructor: (@baseDirectory) ->
  
  getAllImages: (name, host, done) ->
    fs.readdir "#{@baseDirectory}/#{name}", (err, files) =>
      return done err if err

      images = []
      for file in files
        images.push "#{host}/images/#{name}/#{file}" if file[-4..] isnt 'json'

      @_readPlace name, (err, infos) ->
        return done err if err
        infos.images = images
        done null, infos

  getAllInfos: (done) ->
    async.waterfall [
      @_readBaseDirectory.bind(@)
      @_readPlaces.bind(@)
    ], done

  _readBaseDirectory: (done) ->
    fs.readdir @baseDirectory, done

  _readPlaces: (directories, done) ->
    async.map directories, @_readPlace.bind(@), done 

  _readPlace: (directory, done) ->
    path = "#{@baseDirectory}/#{directory}"

    fs.readFile "#{path}/info.json", (err, infosStr) =>
      return done err if err

      try
        infos = JSON.parse infosStr
      catch e
        return done e
      
      # add amount of images by assuming we have only images and the info.json in it
      infos.amount = fs.readdirSync(path).length - 1
      infos.name = "#{directory[0].toUpperCase()}#{directory[1..]}" unless infos.name?
      infos.id = directory
      done null, infos
module.exports = Places