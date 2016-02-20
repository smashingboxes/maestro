Config = require('./config.json')
ApiServer = require('apiserver')
SlackInterface = require('./lib/slack_interface/index')()

server = new ApiServer(port: 8000)
server.use ApiServer.payloadParser()
server.addModule '1', 'slack_interface', SlackInterface
server.router.addRoutes [ [
  '/handle'
  '1/slack_interface#handle'
] ]
server.listen()

console.info 'Server running. Yay!'
