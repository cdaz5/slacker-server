import pick from 'lodash/pick';

/* eslint-disable import/prefer-default-export */
export const formatError = (error, models) => {
  if (error instanceof models.sequelize.ValidationError) {
    return error.errors.map(err => pick(err, ['path', 'message']));
  }
  return [{ path: 'name', message: 'something went wrong' }];
};
