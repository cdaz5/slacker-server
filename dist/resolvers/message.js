'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _graphqlSubscriptions = require('graphql-subscriptions');

var _permissions = require('../permissions');

var _permissions2 = _interopRequireDefault(_permissions);

var _pubsub = require('../pubsub');

var _pubsub2 = _interopRequireDefault(_pubsub);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

const NEW_CHANNEL_MESSAGE = 'NEW_CHANNEL_MESSAGE';

exports.default = {
  Subscription: {
    newChannelMessage: {
      subscribe: _permissions.requiresTeamAccess.createResolver((0, _graphqlSubscriptions.withFilter)(() => _pubsub2.default.asyncIterator(NEW_CHANNEL_MESSAGE), (payload, args) => payload.channelId === args.channelId))
    }
  },
  Message: {
    // url: (parent) => (parent.url ? `${process.env.SERVER_URL || 'http://localhost:3000'}/${parent.url}` : parent.url),
    user: ({ user, userId }, args, { models }) => {
      if (user) {
        return user;
      }
      return models.User.findOne({ where: { id: userId } }, { raw: true });
    }
  },
  Query: {
    messages: _permissions2.default.createResolver(async (parent, { cursor, channelId }, { models, user }) => {
      const channel = await models.Channel.findOne({ raw: true, where: { id: channelId } });

      if (!channel.public) {
        const member = await models.PCMember.findOne({
          raw: true,
          where: { channelId, userId: user.id }
        });
        if (!member) {
          throw new Error('Not Authorized');
        }
      }

      const options = {
        order: [['created_at', 'DESC']],
        where: { channelId },
        limit: 30
      };

      if (cursor) {
        options.where.created_at = {
          [models.op.lt]: cursor
        };
      }

      return models.Message.findAll(options, { raw: true });
    })
  },
  Mutation: {
    createMessage: _permissions2.default.createResolver(async (parent, args, { models, user }) => {
      try {
        const message = await models.Message.create(_extends({}, args, { userId: user.id }));
        const currentUserAndPubsub = async () => {
          const currentUser = await models.User.findOne({
            where: {
              id: user.id
            }
          });

          _pubsub2.default.publish(NEW_CHANNEL_MESSAGE, {
            channelId: args.channelId,
            newChannelMessage: _extends({}, message.dataValues, {
              user: currentUser.dataValues
            })
          });
        };

        currentUserAndPubsub();

        return true;
      } catch (err) {
        console.log(err);
        return false;
      }
    })
  }
};