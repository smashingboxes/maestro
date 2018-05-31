var util = require('util'),
    XRegExp = require('xregexp').XRegExp,
    caseRegExp = /([A-Z]+[a-z]|[A-Z]+)/g,
    HTTP_METHODS = ['head', 'get', 'post', 'put', 'delete', 'trace', 'options', 'connect', 'patch']

var Router = module.exports = function (options) {
  var self = this
  options = options || {}
  Object.keys(options).forEach(function (key) {
    if (!self.__proto__.hasOwnProperty(key)) {
      self[key] = options[key]
    }
  })
  this.modules = null
  this.middlewareList = null
  this.customRoutes = []
  this.defaultRoute = this.defaultRoute || '/:version/:module/:method'
  this.defaultRoutes = Object.create(null)
  this.disabledDefaultRoutes = Object.create(null)
}

Router.prototype.HTTP_METHODS = ['head', 'get', 'post', 'put', 'delete', 'trace', 'options', 'connect', 'patch']

Router.prototype.addRoute = function addRoute(route, endpointPath, defaults, keepDefault) {
  var xRegExp
  var endpointDescription = getEndpointDescription(endpointPath)
  try {
    var module = this.modules[endpointDescription.version][endpointDescription.moduleName]
    var method = module[endpointDescription.methodName]
    var endopoint = createEndpoint(module, method)
  } catch (e) {
    throw new Error(util.format('Can not resolve endopoint %s (%s)', endpointPath, JSON.stringify(endpointDescription)))
  }
  if (route.constructor === String) {
    xRegExp = XRegExp('^' + route.replace(/\/:([\w]+)/g, '(?:/(?<$1>[^/]+)?)?') + '/*$')
  } else if (route.xregexp !== undefined) {
    xRegExp = route
  } else {
    throw new Error(util.format('Route must be a String or a XRegExp: %s', route))
  }
  this.customRoutes.push({
    xRegExp: xRegExp,
    endpoint: endopoint,
    defaults: defaults || Object.create(null)
  })
  if (!keepDefault) {
    this.disabledDefaultRoutes[
      this.getDefaultRoute(
        endpointDescription.version,
        normalizeCase(endpointDescription.moduleName),
        normalizeCase(endpointDescription.methodName)
      )
    ] = true
  }
  return this
}

Router.prototype.addRoutes = function (routes) {
  var self = this
  routes.forEach(function (route) {
    self.addRoute.apply(self, route)
  })
}

Router.prototype.getDefaultRoute = function (version, moduleName, methodName) {
  return this.defaultRoute.replace(':version', version)
                          .replace(':module', moduleName)
                          .replace(':method', methodName)
}

Router.prototype.get = function (request) {
  return this.getDefault(request) || this.getCustom(request)
}

Router.prototype.getDefault = function (request) {
  var pathname = request.pathname
  if (!this.disabledDefaultRoutes[pathname]) {
    var endpoint = this.defaultRoutes[pathname]
    return endpoint && endpoint[request.method]
  }
}

Router.prototype.getCustom = function (request) {
  var self = this
  var pathname = request.pathname
  var endpoint, xRegExpResult, routeParams, chain
  this.customRoutes.every(function (route) {
    if (pathname.match(route.xRegExp)) {
      // check endpoint availability for the current http method
      endpoint = route.endpoint[request.method]
      if (!endpoint) {
        return true
      }
      // parse route parameters and merge into the request.querystring object
      xRegExpResult = XRegExp.exec(pathname, route.xRegExp)
      routeParams = getRouteParams(xRegExpResult, route.xRegExp, route.defaults)
      fillObject(request.querystring, routeParams)
      // get the chain
      chain = getMiddlewareChain(self.middlewareList, pathname)
      chain.push(endpoint)
      return false
    }
    return true
  })
  return chain
}

Router.prototype.update = function (modules, middlewareList) {
  var self = this
  var routes = Object.create(null)
  var conflictsMap = Object.create(null)
  Object.keys(modules).forEach(function (version) {
    Object.keys(modules[version]).forEach(function (moduleName) {
      var module_name = normalizeCase(moduleName)
      var module = modules[version][moduleName]
      var methodNames = Object.keys(module.__proto__).concat(Object.keys(module))
      methodNames.forEach(function (methodName) {
        if (methodName[0] === '_') {
          return
        }
        var method = module[methodName]
        var method_name = normalizeCase(methodName)
        var route = self.getDefaultRoute(version, module_name, method_name)
        if (routes[route]) {
          throw new Error(util.format('Routing conflict on "%s": %s.%s.%s is anbiguous with %s.%s.%s',
            route,
            conflictsMap[route].version, conflictsMap[route].moduleName, conflictsMap[route].methodName,
            version, moduleName, methodName
          ))
        }
        conflictsMap[route] = { version: version, moduleName: moduleName, methodName: methodName }
        routes[route] = createEndpointChain(module, method, getMiddlewareChain(middlewareList, route))
      })
    })
  })
  this.modules = modules
  this.middlewareList = middlewareList
  this.defaultRoutes = routes
}

function normalizeCase(str) {
  return str.replace(/([A-Z][^A-Z]*)/g, '_$1').replace(/^(_)/, '').toLowerCase()
}

function getEndpointDescription(endpoint) {
  var xRegExp = XRegExp('(?<version>[^/]+)/(?<moduleName>[^#]+)#(?<methodName>.+)')
  var result = XRegExp.exec(endpoint, xRegExp)
  return {
    version: result.version,
    moduleName: result.moduleName,
    methodName: result.methodName
  }
}

function getRouteParams(xRegExpResult, xRegExp, defaults) {
  var params = Object.create(null)
  if (xRegExp.xregexp.captureNames) {
    xRegExp.xregexp.captureNames.forEach(function (paramName) {
      if (xRegExpResult[paramName] !== undefined) {
        params[paramName] = xRegExpResult[paramName]
      }
    })
  }
  Object.keys(defaults).forEach(function (paramName) {
    if (params[paramName] === undefined) {
      params[paramName] = defaults[paramName]
    }
  })
  return params
}

function getMiddlewareChain(middlewareList, route) {
  var chain = []
  if (middlewareList) {
    middlewareList.forEach(function (middleware) {
      if (route.match(middleware.route)) {
        chain.push(middleware.handle)
      }
    })
  }
  return chain
}

function getLastChainRing(endpoint, scope) {
  return function (request, response, callback) {
    try {
      endpoint(request, response, scope)
      callback()
    } catch (err) {
      callback(err)
    }
  }
}

function createEndpoint(scope, method) {
  var endpoint = Object.create(null)
  if (typeof method === 'function') {
    var endpointFn = getLastChainRing(method.bind(scope), scope)
    Router.prototype.HTTP_METHODS.forEach(function (httpMethod) {
      endpoint[httpMethod.toUpperCase()] = endpointFn
    })
  } else {
    Router.prototype.HTTP_METHODS.forEach(function (httpMethod) {
      if (typeof method[httpMethod] === 'function') {
        endpoint[httpMethod.toUpperCase()] = getLastChainRing(method[httpMethod].bind(scope), scope)
      }
    })
  }
  return endpoint
}

function createEndpointChain(scope, method, chain) {
  var endpointChain = Object.create(null)
  if (typeof method === 'function') {
    chain.push(getLastChainRing(method.bind(scope), scope))
    Router.prototype.HTTP_METHODS.forEach(function (httpMethod) {
      endpointChain[httpMethod.toUpperCase()] = chain
    })
  } else {
    Router.prototype.HTTP_METHODS.forEach(function (httpMethod) {
      if (typeof method[httpMethod] === 'function') {
        endpointChain[httpMethod.toUpperCase()] = chain.slice(0)
        endpointChain[httpMethod.toUpperCase()].push(getLastChainRing(method[httpMethod].bind(scope), scope))
      }
    })
  }
  return endpointChain
}

function fillObject (targetObj, fillObj) {
  Object.keys(fillObj).forEach(function (key) {
    if (!targetObj.hasOwnProperty(key)) {
      targetObj[key] = fillObj[key]
    }
  })
}
