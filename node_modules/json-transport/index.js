module.exports = process.env.JSON_TRANSPORT_COV
   ? require('./lib-cov/json-transport')
   : require('./lib/json-transport')