import request from 'reqwest';

class Fetch {
  constructor() {
    this.BASE_PATH = 'http://localhost:8080/'
  }

  places() {
    let req = request(`${this.BASE_PATH}places`);
    req.fail(this._handleError);
    return req;
  }

  place(id) {
    let req = request(`${this.BASE_PATH}places/${id}`)
    req.fail(this._handleError);
    return req;
  }

  image(path) {
    let req = request(`${this.BASE_PATH}images/${path}`)
    req.fail(this._handleError);
    return req;
  }

  _handleError(err, msg) {
    console.error('failed to fetch insurances');
    console.error(err, msg);
  }
}

export default Fetch;
