import { withFilter } from 'graphql-subscriptions';

import requiresAuth, { requiresTeamAccess } from '../permissions';
import pubsub from '../pubsub';

const NEW_CHANNEL_MESSAGE = 'NEW_CHANNEL_MESSAGE';

export default {
  Subscription: {
    newChannelMessage: {
      subscribe: requiresTeamAccess.createResolver(withFilter(
        () => pubsub.asyncIterator(NEW_CHANNEL_MESSAGE),
        (payload, args) => payload.channelId === args.channelId,
      )),
    },
  },
  Message: {
    // url: (parent) => (parent.url ? `${process.env.SERVER_URL || 'http://localhost:3000'}/${parent.url}` : parent.url),
    user: ({ user, userId }, args, { userLoader }) => {
      if (user) {
        return user;
      }
      return userLoader.load(userId);
    },
  },
  Query: {
    messages: requiresAuth.createResolver(async (parent, { cursor, channelId }, { models, user }) => {
      const channel = await models.Channel.findOne({ raw: true, where: { id: channelId } });

      if (!channel.public) {
        const member = await models.PCMember.findOne({
          raw: true,
          where: { channelId, userId: user.id },
        });
        if (!member) {
          throw new Error('Not Authorized');
        }
      }

      const options = {
        order: [['created_at', 'DESC']],
        where: { channelId },
        limit: 30,
      };

      if (cursor) {
        options.where.created_at = {
          [models.op.lt]: cursor,
        };
      }

      return models.Message.findAll(options, { raw: true });
    }),
  },
  Mutation: {
    createMessage: requiresAuth.createResolver(async (parent, args, { models, user }) => {
      try {
        const message = await models.Message.create({ ...args, userId: user.id });
        const currentUserAndPubsub = async () => {
          const currentUser = await models.User.findOne({
            where: {
              id: user.id,
            },
          });

          pubsub.publish(NEW_CHANNEL_MESSAGE, {
            channelId: args.channelId,
            newChannelMessage: {
              ...message.dataValues,
              user: currentUser.dataValues,
            },
          });
        };

        currentUserAndPubsub();

        return true;
      } catch (err) {
        console.log(err);
        return false;
      }
    }),
  },
};
