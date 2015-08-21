# Application config
Config = require('./config.json')
# The Server
ApiServer = require('apiserver')
server = new ApiServer(port: 8000)
# Control modules used by the ApiServer
SlackInterface = require('./lib/slack_interface/index')()
# Parse POST Payloads
server.use ApiServer.payloadParser()
# Add control modules
server.addModule '1', 'slack_interface', SlackInterface
# Routing
server.router.addRoutes [ [
  '/handle'
  '1/slack_interface#handle'
] ]
# Let's go
server.listen()
console.info 'Server running. Yay!'
