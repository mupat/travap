const restify = require('restify');
const plugins = require('restify-plugins');
const package = require('./package.json');
const Places = require('./places');

const placesPath = `${__dirname}/../places`
const server = restify.createServer({
  name: package.name,
  version: package.version
});

server.use(plugins.acceptParser(server.acceptable));
server.use(plugins.queryParser());

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
