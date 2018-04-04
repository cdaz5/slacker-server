import Sequelize from 'sequelize';

const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));

export default async () => {
  let maxReconnects = 20;
  let connected = false;
  const sequelize = new Sequelize(process.env.TEST_DB || 'slack', 'chrisdascoli', 'postgres', {
    dialect: 'postgres',
    operatorsAliases: Sequelize.Op,
    host: process.env.DB_HOST || 'localhost',
    define: {
      underscored: true,
    },
  });

  while (!connected && maxReconnects) {
    try {
      /* eslint-disable-next-line no-await-in-loop */
      await sequelize.authenticate();
      connected = true;
    } catch (err) {
      /* eslint-disable-next-line no-console */
      console.log('Attempting to reconnect in 5 seconds');
      maxReconnects -= 1;
      /* eslint-disable-next-line no-await-in-loop */
      await sleep(5000);
    }
  }

  if (!connected) {
    return null;
  }

  const models = {
    User: sequelize.import('./user'),
    Message: sequelize.import('./message'),
    Channel: sequelize.import('./channel'),
    Team: sequelize.import('./team'),
    Member: sequelize.import('./member'),
    DirectMessage: sequelize.import('./directMessage'),
    PCMember: sequelize.import('./pcmember'),
  };

  Object.keys(models).forEach((modelName) => {
    if (models[modelName].associate) {
      models[modelName].associate(models);
    }
  });

  models.sequelize = sequelize;
  models.Sequelize = Sequelize;
  models.op = Sequelize.Op;

  return models;
};
