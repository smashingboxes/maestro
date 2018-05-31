module.exports = process.env.APISERVER_ROUTER_COV
   ? require('./lib-cov/router')
   : require('./lib/router')