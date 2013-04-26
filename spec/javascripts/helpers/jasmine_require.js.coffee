JasmineRequire = {

  require: (executionContext, modulesToRequire, callback) ->
    @requireWithStubs(executionContext, {}, modulesToRequire, callback)

  requireWithStubs: (executionContext, stubs, modulesToRequire, callback) ->
    new AsyncSpec(executionContext).beforeEach((done) =>
      context = @_createContext(stubs)
      context.require([ "jquery" ], ($) ->
        $(document).on("mobileinit", () ->
          $.mobile.ajaxEnabled = false
          $.mobile.linkBindingEnabled = false
          $.mobile.hashListeningEnabled = false
          $.mobile.pushStateEnabled = false
          done()
        )
      )
      context.require(modulesToRequire, () ->
        callback.apply(executionContext, arguments)
        context.require([ "jquerymobile" ])
      )
    )
    afterEach(() ->
      $(".ui-loader, .ui-popup-screen, .ui-popup-container").remove()
    )

  _createContext: (stubs={}) ->
    map = {}
    for key, value of stubs
      map[key] = "stub#{key}"
    newRequire = require.config(
      context: Math.floor(Math.random() * 1000000)
      baseUrl: "/tmp/assets/javascripts/unoptimized/lib"
      paths:
        app: "../app"
        jquery: "jquery-1.9.1.min"
        jquerymobile: "jquery.mobile-1.3.0.min"
        underscore: "underscore-1.4.4.min"
        backbone: "backbone-0.9.9.min"
        text : "text-2.0.3"
      shim:
        underscore:
          exports: "_"
        backbone:
          deps: [ "jquery", "underscore" ]
          exports: "Backbone"
      map:
        "*": map
    )
    for key, value of stubs
      do (value) ->
        define("stub#{key}", () -> value)
    require: newRequire

}

window.jasmineRequire = () -> JasmineRequire.require.apply(JasmineRequire, arguments)
window.jasmineRequireWithStubs = () -> JasmineRequire.requireWithStubs.apply(JasmineRequire, arguments)
