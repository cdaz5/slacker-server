import { formatError } from '../utils/FormatErrors';
import requiresAuth from '../permissions';

export default {
  Mutation: {
    createChannel: requiresAuth.createResolver(async (parent, args, { models }) => {
      try {
        const team = await models.Team.findOne({ where: { id: args.teamId } }, { raw: true });
        if (team.owner !== user.id) {
          return {
            ok: false,
            errors: [
              {
                path: 'name',
                message: 'Must be owner to create channels',
              },
            ],
          };
        }

        const channel = await models.Channel.create(args);
        return {
          ok: true,
          channel,
        };
      } catch (err) {
        console.log(err);
        return {
          ok: false,
          errors: formatError(err, models),
        };
      }
    }),
  },
};
