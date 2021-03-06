fs = require 'fs'
async = require 'async'
exif = require 'exiftool.js'

class Places
  constructor: (@baseDirectory) ->
  
  getOne: (name, host, done) ->
    async.waterfall [
      @_readBaseDirectory.bind(@, "/#{name}")
      @_readImages.bind(@, name, host)
      @_readPlace.bind(@, name)
    ], done    

  getAll: (done) ->
    async.waterfall [
      @_readBaseDirectory.bind(@, '')
      @_readPlaces.bind(@)
    ], done

  _readImages: (name, host, files, done) ->
    images = []
    for file in files # remove json file
      unless file[-4..] is 'json' or file[0..0] is '.'
        images.push file 

    async.map images, 
      @_readImage.bind(@, "#{@baseDirectory}/#{name}", "#{host}/images/#{name}"), 
      done

  _readImage: (path, uri, img, done) ->
    exif.getExifFromLocalFileUsingNodeFs fs, "#{path}/#{img}", (info) ->
      date = info.CreateDate or info.ModifyDate or ' '
      splittedDate = date.split ' '
      done null, {
        date: splittedDate[0].replace(/:/g, '-')
        time: splittedDate[1]
        model: info.Model
        orientation: info.Orientation
        href: "#{uri}/#{img}"
      }

  _readBaseDirectory: (path, done) ->
    fs.readdir @baseDirectory + path, done

  _readPlaces: (directories, done) ->
    folders = []
    for directory in directories # remove json file
      unless directory[0..0] is '.'
        folders.push directory 
    async.map folders, @_readPlace.bind(@), done 

  _readPlace: (directory, images, done) ->
    path = "#{@baseDirectory}/#{directory}"
    if done is undefined
      done = images
      images = undefined

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
      infos.images = images if images?

      done null, infos
module.exports = Places