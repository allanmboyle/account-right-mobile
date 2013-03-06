jasmineContext = (stubs = {}) ->
  map = {}
  for value, key of stubs
    map[key] = 'stub' + key
  newRequire = require.config(
    context: Math.floor(Math.random() * 1000000)
    baseUrl: "/tmp/assets/javascripts/unoptimized/lib"
    paths:
      app: "../app"
      jquery: "jquery-1.9.1.min"
      jquerymobile: "jquery.mobile-1.3.0.min"
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

jasmineRequire = (executionContext, modulesToRequire, callback) ->
  new AsyncSpec(executionContext).beforeEach((done) ->
    context = executionContext.requireContext = jasmineContext()
    context.require([ "jquery" ], ($) ->
      $(document).on("mobileinit", () -> done())
    )
    context.require(modulesToRequire, () ->
      callback.apply(executionContext, arguments)
      context.require([ "jquerymobile" ])
    )
  )

window.jasmineRequire = jasmineRequire
