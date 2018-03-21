'use strict';

var _express = require('express');

var _express2 = _interopRequireDefault(_express);

var _bodyParser = require('body-parser');

var _bodyParser2 = _interopRequireDefault(_bodyParser);

var _apolloServerExpress = require('apollo-server-express');

var _graphqlTools = require('graphql-tools');

var _cors = require('cors');

var _cors2 = _interopRequireDefault(_cors);

var _path = require('path');

var _path2 = _interopRequireDefault(_path);

var _mergeGraphqlSchemas = require('merge-graphql-schemas');

var _jsonwebtoken = require('jsonwebtoken');

var _jsonwebtoken2 = _interopRequireDefault(_jsonwebtoken);

var _http = require('http');

var _graphql = require('graphql');

var _subscriptionsTransportWs = require('subscriptions-transport-ws');

var _dataloader = require('dataloader');

var _dataloader2 = _interopRequireDefault(_dataloader);

var _auth = require('./auth');

var _models = require('./models');

var _models2 = _interopRequireDefault(_models);

var _batchFunctions = require('./batchFunctions');

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

const SECRET = 'dragons';
const SECRET2 = 'excalibur';

const resolvers = (0, _mergeGraphqlSchemas.mergeResolvers)((0, _mergeGraphqlSchemas.fileLoader)(_path2.default.join(__dirname, './resolvers')));

const typeDefs = (0, _mergeGraphqlSchemas.mergeTypes)((0, _mergeGraphqlSchemas.fileLoader)(_path2.default.join(__dirname, './schema')));

const schema = (0, _graphqlTools.makeExecutableSchema)({
  typeDefs,
  resolvers
});

const PORT = 3000;

const app = (0, _express2.default)();
app.use((0, _cors2.default)('*'));

const addUser = async (req, res, next) => {
  const token = req.headers['x-token'];
  if (token) {
    try {
      const { user } = _jsonwebtoken2.default.verify(token, SECRET);
      req.user = user;
    } catch (err) {
      const refreshToken = req.headers['x-refresh-token'];
      const newTokens = await (0, _auth.refreshTokens)(token, refreshToken, _models2.default, SECRET, SECRET2);
      if (newTokens.token && newTokens.refreshToken) {
        res.set('Access-Control-Expose-Headers', 'x-token, x-refresh-token');
        res.set('x-token', newTokens.token);
        res.set('x-refresh-token', newTokens.refreshToken);
      }
      req.user = newTokens.user;
    }
  }
  next();
};

app.use(addUser);

const graphqlEndpoint = '/graphql';

app.use(graphqlEndpoint, _bodyParser2.default.json(), (0, _apolloServerExpress.graphqlExpress)(req => ({
  schema,
  context: {
    models: _models2.default,
    user: req.user,
    SECRET,
    SECRET2,
    channelLoader: new _dataloader2.default(ids => (0, _batchFunctions.channelBatcher)(ids, _models2.default, req.user)),
    serverUrl: `${req.protocol}://${req.get('host')}`
  }
})));

app.use('/graphiql', (0, _apolloServerExpress.graphiqlExpress)({
  endpointURL: graphqlEndpoint,
  subscriptionsEndpoint: 'ws://localhost:3000/subscriptions'
}));
const server = (0, _http.createServer)(app);

_models2.default.sequelize.sync().then(() => {
  server.listen(PORT, () => {
    /* eslint-disable-next-line no-console */
    console.log(`server listening on ${PORT}`);
    /* eslint-disable-next-line no-new */
    new _subscriptionsTransportWs.SubscriptionServer({
      execute: _graphql.execute,
      subscribe: _graphql.subscribe,
      schema,
      onConnect: async ({ token, refreshToken }, webSocket) => {
        if (token && refreshToken) {
          try {
            const { user } = _jsonwebtoken2.default.verify(token, SECRET);
            return { models: _models2.default, user };
          } catch (err) {
            const newTokens = await (0, _auth.refreshTokens)(token, refreshToken, _models2.default, SECRET, SECRET2);
            return { models: _models2.default, user: newTokens.user };
          }
        }
        return { models: _models2.default };
      }
    }, {
      server,
      path: '/subscriptions'
    });
  });
});