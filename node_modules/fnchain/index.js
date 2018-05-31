module.exports = process.env.FNCHAIN_COV
   ? require('./lib-cov/fnchain')
   : require('./lib/fnchain');