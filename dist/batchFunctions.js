"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
/* eslint-disable import/prefer-default-export */
const channelBatcher = exports.channelBatcher = async (ids, models, user) => {
  const results = await models.sequelize.query(`
  select distinct on (id) *
  from channels as c 
  left outer join pcmembers as pc 
  on c.id = pc.channel_id
  where c.team_id in (:teamIds) and (c.public = true or pc.user_id = :userId);`, {
    replacements: { teamIds: ids, userId: user.id },
    model: models.Channel,
    raw: true
  });

  const data = {};
  results.forEach(result => {
    if (data[result.team_id]) {
      data[result.team_id].push(result);
    } else {
      data[result.team_id] = [result];
    }
  });

  return ids.map(id => data[id]);
};