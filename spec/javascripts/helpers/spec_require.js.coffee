specContext = (stubs = {}) ->
  map = {}
  for value, key of stubs
    map[key] = 'stub' + key
  newRequire = require.config(
    context: Math.floor(Math.random() * 1000000)
    baseUrl: "/tmp/assets/javascripts/unoptimized/lib"
    paths:
      app: "../app"
      jquery: "jquery-1.8.3.min"
      jquerymobile: "jquery.mobile-1.2.0.min"
      underscore: "lodash-0.10.0.min"
      backbone: "backbone-0.9.9.min"
      text : "text-2.0.3"
    shim:
      backbone:
        deps: [ "jquery", "underscore" ]
        exports: "Backbone"
    map:
      "*": map
  )
  for value, key of stubs
    define('stub' + key, () -> value)
  require: newRequire

specRequire = (executionContext, modulesToRequire, callback) ->
  async = new AsyncSpec(executionContext)
  async.beforeEach((done) ->
    unless (executionContext.requireContext?)
      context = executionContext.requireContext = specContext()
      context.require(modulesToRequire, () ->
        callback.apply(executionContext, arguments)
        done()
      )
    else
      done()
  )

window.specRequire = specRequire
