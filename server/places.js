'use_strict'
const Promise = require('bluebird');
const glob = Promise.promisify(require('glob'));
const fs = Promise.promisifyAll(require('fs'));
const path = require('path');

class Places {
  constructor(server, path) {
    this.path = path;
    this._cachePlaces();

    server.get('/places', this.all.bind(this));
    server.get('/places/:id', this.one.bind(this));
    server.get(/images\/(.*)/, this.image.bind(this));
  }

  all(req, res, next) {
    res.send(this.places);
    next();
  }

  one(req, res, next) {
    res.send(this.places.find(place => place.id == req.params.id));
    next();
  }

  image(req, res, next) {
    fs.readFileAsync(path.join(this.path, req.params[0]))
    .then((file) => {
      res.end(file);
      next();
    })
    .catch((error) => {
      next(error);
    })
  }

  _cachePlaces() {
    fs.readdirAsync(this.path)
    .map((dir) => {
      return Promise.join(
        fs.readFileAsync(path.join(this.path, dir, 'info.json')),
        glob(`${this.path}/${dir}/**/*.+(jpeg|jpg|png)`),
        (info, images) => {
          let obj = {
            id: dir,
            image: images.map(image => `${dir}/${path.basename(image)}`)
          }
          return Object.assign(obj, JSON.parse(info));
        }
      );
    })
    .then((result) => {
      this.places = result;
    })
    .catch((error) => {
      console.error('couldnt cache places', error);
    });
  }
}

module.exports = Places;
