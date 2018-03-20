'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _extends2 = require('babel-runtime/helpers/extends');

var _extends3 = _interopRequireDefault(_extends2);

var _regenerator = require('babel-runtime/regenerator');

var _regenerator2 = _interopRequireDefault(_regenerator);

var _defineProperty2 = require('babel-runtime/helpers/defineProperty');

var _defineProperty3 = _interopRequireDefault(_defineProperty2);

var _asyncToGenerator2 = require('babel-runtime/helpers/asyncToGenerator');

var _asyncToGenerator3 = _interopRequireDefault(_asyncToGenerator2);

var _graphqlSubscriptions = require('graphql-subscriptions');

var _permissions = require('../permissions');

var _permissions2 = _interopRequireDefault(_permissions);

var _pubsub = require('../pubsub');

var _pubsub2 = _interopRequireDefault(_pubsub);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var NEW_CHANNEL_MESSAGE = 'NEW_CHANNEL_MESSAGE';

exports.default = {
  Subscription: {
    newChannelMessage: {
      subscribe: _permissions.requiresTeamAccess.createResolver((0, _graphqlSubscriptions.withFilter)(function () {
        return _pubsub2.default.asyncIterator(NEW_CHANNEL_MESSAGE);
      }, function (payload, args) {
        return payload.channelId === args.channelId;
      }))
    }
  },
  Message: {
    // url: (parent, args, { serverUrl }) => (parent.url ? `${serverUrl}/${parent.url}` : parent.url),
    user: function user(_ref, args, _ref2) {
      var _user = _ref.user,
          userId = _ref.userId;
      var models = _ref2.models;

      if (_user) {
        return _user;
      }
      return models.User.findOne({ where: { id: userId } }, { raw: true });
    }
  },
  Query: {
    messages: _permissions2.default.createResolver(function () {
      var _ref3 = (0, _asyncToGenerator3.default)( /*#__PURE__*/_regenerator2.default.mark(function _callee(parent, _ref4, _ref5) {
        var cursor = _ref4.cursor,
            channelId = _ref4.channelId;
        var models = _ref5.models,
            user = _ref5.user;
        var channel, member, options;
        return _regenerator2.default.wrap(function _callee$(_context) {
          while (1) {
            switch (_context.prev = _context.next) {
              case 0:
                _context.next = 2;
                return models.Channel.findOne({ raw: true, where: { id: channelId } });

              case 2:
                channel = _context.sent;

                if (channel.public) {
                  _context.next = 9;
                  break;
                }

                _context.next = 6;
                return models.PCMember.findOne({
                  raw: true,
                  where: { channelId: channelId, userId: user.id }
                });

              case 6:
                member = _context.sent;

                if (member) {
                  _context.next = 9;
                  break;
                }

                throw new Error('Not Authorized');

              case 9:
                options = {
                  order: [['created_at', 'DESC']],
                  where: { channelId: channelId },
                  limit: 30
                };


                if (cursor) {
                  options.where.created_at = (0, _defineProperty3.default)({}, models.op.lt, cursor);
                }

                return _context.abrupt('return', models.Message.findAll(options, { raw: true }));

              case 12:
              case 'end':
                return _context.stop();
            }
          }
        }, _callee, undefined);
      }));

      return function (_x, _x2, _x3) {
        return _ref3.apply(this, arguments);
      };
    }())
  },
  Mutation: {
    createMessage: _permissions2.default.createResolver(function () {
      var _ref6 = (0, _asyncToGenerator3.default)( /*#__PURE__*/_regenerator2.default.mark(function _callee3(parent, args, _ref7) {
        var models = _ref7.models,
            user = _ref7.user;
        var message, currentUserAndPubsub;
        return _regenerator2.default.wrap(function _callee3$(_context3) {
          while (1) {
            switch (_context3.prev = _context3.next) {
              case 0:
                _context3.prev = 0;
                _context3.next = 3;
                return models.Message.create((0, _extends3.default)({}, args, { userId: user.id }));

              case 3:
                message = _context3.sent;

                currentUserAndPubsub = function () {
                  var _ref8 = (0, _asyncToGenerator3.default)( /*#__PURE__*/_regenerator2.default.mark(function _callee2() {
                    var currentUser;
                    return _regenerator2.default.wrap(function _callee2$(_context2) {
                      while (1) {
                        switch (_context2.prev = _context2.next) {
                          case 0:
                            _context2.next = 2;
                            return models.User.findOne({
                              where: {
                                id: user.id
                              }
                            });

                          case 2:
                            currentUser = _context2.sent;


                            _pubsub2.default.publish(NEW_CHANNEL_MESSAGE, {
                              channelId: args.channelId,
                              newChannelMessage: (0, _extends3.default)({}, message.dataValues, {
                                user: currentUser.dataValues
                              })
                            });

                          case 4:
                          case 'end':
                            return _context2.stop();
                        }
                      }
                    }, _callee2, undefined);
                  }));

                  return function currentUserAndPubsub() {
                    return _ref8.apply(this, arguments);
                  };
                }();

                currentUserAndPubsub();

                return _context3.abrupt('return', true);

              case 9:
                _context3.prev = 9;
                _context3.t0 = _context3['catch'](0);

                console.log(_context3.t0);
                return _context3.abrupt('return', false);

              case 13:
              case 'end':
                return _context3.stop();
            }
          }
        }, _callee3, undefined, [[0, 9]]);
      }));

      return function (_x4, _x5, _x6) {
        return _ref6.apply(this, arguments);
      };
    }())
  }
};