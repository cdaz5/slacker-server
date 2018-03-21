'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _auth = require('../auth');

var _FormatErrors = require('../utils/FormatErrors');

var _permissions = require('../permissions');

var _permissions2 = _interopRequireDefault(_permissions);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

exports.default = {
  User: {
    teams: (parent, args, { models, user }) => models.sequelize.query('select * from teams as team join members as member on team.id = member.team_id where member.user_id = ?', {
      replacements: [user.id],
      model: models.Team,
      raw: true
    })
    // channels: (parent, args, { models, user }) => models.sequelize.query(
    //   select * from pcmembers as pc, members as m where m.team_id=1 and pc.channel_id = 9;
    // )
  },
  Query: {
    getUser: (parent, { userId }, { models }) => models.User.findOne({ where: { id: userId } }),
    allUsers: (parent, args, { models }) => models.User.findAll(),
    me: _permissions2.default.createResolver((parent, args, { models, user }) => models.User.findOne({ where: { id: user.id } }))
  },
  Mutation: {
    login: (parent, { email, password }, { models, SECRET, SECRET2 }) => (0, _auth.tryLogin)(email, password, models, SECRET, SECRET2),
    register: async (parent, args, { models }) => {
      try {
        const user = await models.User.create(args);
        return {
          ok: true,
          user
        };
      } catch (err) {
        console.log(err);
        return {
          ok: false,
          errors: (0, _FormatErrors.formatError)(err, models)
        };
      }
    }
  }
};