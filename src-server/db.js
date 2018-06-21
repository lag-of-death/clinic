const pgPromise = require(`pg-promise`);
const pg        = pgPromise({});

pg.pg.types.setTypeParser(20, `text`, parseInt);

const client = pg(process.env.DATABASE_URL);

module.exports = client;
