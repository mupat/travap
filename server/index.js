const restify = require('restify');
const package = require('./package.json');
const Places = require('./places');

const placesPath = `${__dirname}/../places`
const server = restify.createServer({
  name: package.name,
  version: package.version
});

server.use(restify.acceptParser(server.acceptable));
server.use(restify.queryParser());
server.use(restify.CORS());

server.opts(/.+/, (req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
  res.header('Access-Control-Allow-Headers', 'Content-Type, X-Requested-With');
  res.send(200);
});

places = new Places(placesPath);
server.get('/places', (req, res, next) => {
  res.send(places.all());
  next();
});

server.get('/places/:id', (req, res, next) => {
  res.send(places.one(req.params.id));
  next();
});

server.get(/images\/(.*)/, (req, res, next) => {
  places.image(req.params[0])
  .then((file) => {
    res.end(file);
    next();
  })
  .catch((error) => {
    next(error);
  });
});

server.listen(8080, () => {
  console.log('%s listening at %s', server.name, server.url);
});
