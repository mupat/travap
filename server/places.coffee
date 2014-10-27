fs = require 'fs'
async = require 'async'
exif = require('exiftool.js')

class Places
  constructor: (@baseDirectory) ->
  
  getAllImages: (name, host, done) ->
    fs.readdir "#{@baseDirectory}/#{name}", (err, files) =>
      return done err if err

      async.map files, 
        @_getOneImage.bind(@, "#{@baseDirectory}/#{name}", "#{host}/images/#{name}"), 
        (err, images) =>
          return done err if err
          @_readPlace name, (err, infos) ->
            return done err if err
            infos.images = images
            done null, infos



      # images = []
      # for file in files
      #   continue if file[-4..] is 'json'
      #   exif.getExifFromLocalFileUsingNodeFs fs, "#{@baseDirectory}/#{name}/#{file}", (obj) ->
      #     console.log 'done', obj

      #   images.push {
      #     href: "#{host}/images/#{name}/#{file}"
      #   }

      
  getAllInfos: (done) ->
    async.waterfall [
      @_readBaseDirectory.bind(@)
      @_readPlaces.bind(@)
    ], done

  _getOneImage: (path, uri, img, done) ->
    return done null, {} if img[-4..] is 'json'
    exif.getExifFromLocalFileUsingNodeFs fs, "#{path}/#{img}", (info) ->
      console.log 'infos', info
      done null, {
        date: info.CreateDate
        model: info.Model
        height: info.ExifImageHeight
        width: info.ExifImageWidth
        href: "#{uri}/#{img}"
      }

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