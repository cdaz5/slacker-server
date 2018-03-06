import express from 'express';
import bodyParser from 'body-parser';
import { graphqlExpress, graphiqlExpress } from 'apollo-server-express';
import { makeExecutableSchema } from 'graphql-tools';
import cors from 'cors';
import path from 'path';
import { fileLoader, mergeTypes, mergeResolvers } from 'merge-graphql-schemas';
import jwt from 'jsonwebtoken';
import { createServer } from 'http';
import { execute, subscribe } from 'graphql';
import { SubscriptionServer } from 'subscriptions-transport-ws';

import { refreshTokens } from './auth';
import models from './models';

const SECRET = 'dragons';
const SECRET2 = 'excalibur';

const resolvers = mergeResolvers(fileLoader(path.join(__dirname, './resolvers')));

const typeDefs = mergeTypes(fileLoader(path.join(__dirname, './schema')));

const schema = makeExecutableSchema({
  typeDefs,
  resolvers,
});

const PORT = 3000;

const app = express();
app.use(cors('*'));

const addUser = async (req, res, next) => {
  const token = req.headers['x-token'];
  if (token) {
    try {
      const { user } = jwt.verify(token, SECRET);
      req.user = user;
    } catch (err) {
      const refreshToken = req.headers['x-refresh-token'];
      const newTokens = await refreshTokens(token, refreshToken, models, SECRET, SECRET2);
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

app.use(
  graphqlEndpoint,
  bodyParser.json(),
  graphqlExpress(req => ({
    schema,
    context: {
      models,
      user: req.user,
      SECRET,
      SECRET2,
    },
  })),
);

app.use(
  '/graphiql',
  graphiqlExpress({
    endpointURL: graphqlEndpoint,
    subscriptionsEndpoint: 'ws://localhost:3000/subscriptions',
  }),
);
const server = createServer(app);

models.sequelize.sync().then(() => {
  server.listen(PORT, () => {
    /* eslint-disable-next-line no-console */
    console.log(`server listening on ${PORT}`);
    /* eslint-disable-next-line no-new */
    new SubscriptionServer(
      {
        execute,
        subscribe,
        schema,
        onConnect: async ({ token, refreshToken }, webSocket) => {
          if (token && refreshToken) {
            let user = null;
            try {
              const payload = jwt.verify(token, SECRET);
              user = payload.user;
            } catch (err) {
              const newTokens = await refreshTokens(token, refreshToken, models, SECRET, SECRET2);
              user = newTokens.user;
            }
            if (!user) {
              throw new Error('Invalid tokens');
            }

            const member = await models.Member.findOne({ where: { teamId: 1, userId: user.id } });

            if (!member) {
              throw new Error('You are not a member of this team');
            }
            return true;
          }
          throw new Error('Missing tokens!');
        },
      },
      {
        server,
        path: '/subscriptions',
      },
    );
  });
});
