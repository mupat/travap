'use_strict'
const Promise = require('bluebird');
const glob = Promise.promisify(require('glob'));
const fs = Promise.promisifyAll(require('fs'));
const path = require('path');

class Places {
  constructor(path) {
    this.path = path;
    this._cachePlaces();
  }

  all() {
    return this.places;
  }

  one(id) {
    return this.places.find(place => place.id == id)
  }

  image(image_path) {
    return fs.readFileAsync(path.join(this.path, image_path))
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
            images: images.map(image => `${dir}/${path.basename(image)}`),
            image_count: images.length
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
