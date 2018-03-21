'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _FormatErrors = require('../utils/FormatErrors');

var _permissions = require('../permissions');

var _permissions2 = _interopRequireDefault(_permissions);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

exports.default = {
  Mutation: {
    getOrCreateChannel: _permissions2.default.createResolver(async (parent, { teamId, members }, { user, models }) => {
      const member = await models.Member.findOne({ where: { teamId, userId: user.id } }, { raw: true });

      if (!member) {
        throw new Error('Not Authorized');
      }

      const allMemebers = [...members, user.id];
      const [data, result] = await models.sequelize.query(`
        select c.id, c.name
        from channels as c, pcmembers pc
        where pc.channel_id = c.id and c.dm = true and c.public = false and c.team_id = ${teamId}
        group by c.id, c.name
        having array_agg(pc.user_id) @> Array[${allMemebers.join(',')}] and count(pc.user_id) = ${allMemebers.length};
      `, { raw: true });
      console.log(data, result);

      if (data.length) {
        return data[0];
      }

      const users = await models.User.findAll({
        raw: true,
        where: {
          id: {
            [models.sequelize.Op.in]: members
          }
        }
      });

      const name = users.map(u => u.username).join(', ');

      const channelData = await models.sequelize.transaction(async transaction => {
        const channel = await models.Channel.create({
          name,
          public: false,
          dm: true,
          teamId
        }, { transaction });

        const cId = channel.dataValues.id;
        const pcmembers = allMemebers.map(m => ({ userId: m, channelId: cId }));
        await models.PCMember.bulkCreate(pcmembers, { transaction });
        return channel.dataValues;
      });
      return {
        id: channelData.id,
        name,
        channel: channelData
      };
    }),
    createChannel: _permissions2.default.createResolver(async (parent, args, { user, models }) => {
      try {
        const member = await models.Member.findOne({ where: { teamId: args.teamId, userId: user.id } }, { raw: true });
        if (!member.admin) {
          return {
            ok: false,
            errors: [{
              path: 'name',
              message: 'Must be owner to create channels'
            }]
          };
        }

        const response = await models.sequelize.transaction(async transaction => {
          const channel = await models.Channel.create(args, { transaction });
          if (!args.public) {
            const members = args.members.filter(m => m !== user.id);
            members.push(user.id);
            const pcmembers = members.map(m => ({ userId: m, channelId: channel.dataValues.id }));
            await models.PCMember.bulkCreate(pcmembers, { transaction });
          }
          return channel;
        });

        return {
          ok: true,
          channel: response
        };
      } catch (err) {
        console.log(err);
        return {
          ok: false,
          errors: (0, _FormatErrors.formatError)(err, models)
        };
      }
    })
  }
};