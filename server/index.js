const restify = require('restify');
const plugins = require('restify-plugins');
const package = require('./../package.json');
const Places = require('./places');

const placesPath = `${__dirname}/../places`
const server = restify.createServer({
  name: package.name,
  version: package.version
});

server.use(plugins.acceptParser(server.acceptable));
server.use(plugins.queryParser());

new Places(server, placesPath);

server.listen(8080, () => {
  console.log('%s listening at %s', server.name, server.url);
});
