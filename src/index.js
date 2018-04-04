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
import DataLoader from 'dataloader';

import { refreshTokens } from './auth';
import getModels from './models';
import { channelBatcher, userBatcher } from './batchFunctions';

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

const graphqlEndpoint = '/graphql';

const server = createServer(app);

getModels().then((models) => {
  if (!models) {
    /* eslint-disable-next-line no-console */
    console.log("Couldn't connect to database");
    return;
  }

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
        channelLoader: new DataLoader(ids => channelBatcher(ids, models, req.user)),
        userLoader: new DataLoader(ids => userBatcher(ids, models)),
        serverUrl: `${req.protocol}://${req.get('host')}`,
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
              try {
                const { user } = jwt.verify(token, SECRET);
                return { models, user };
              } catch (err) {
                const newTokens = await refreshTokens(token, refreshToken, models, SECRET, SECRET2);
                return { models, user: newTokens.user };
              }
            }
            return { models };
          },
        },
        {
          server,
          path: '/subscriptions',
        },
      );
    });
  });
});
