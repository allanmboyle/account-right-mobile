({
  baseUrl: "lib",
  paths: {
    app: "../app",
    jquery: "jquery-1.9.1.min",
    jquerymobile: "jquery.mobile-1.3.0.min",
    underscore: "underscore-1.4.4.min",
    backbone: "backbone-0.9.9.min",
    text: "text-2.0.3",
    accounting: "accounting-0.3.2.min"
  },
  shim: {
    "underscore": {
      exports: "_"
    },
    "backbone": {
      deps: [ "underscore", "jquery" ],
      exports: "Backbone"
    }
  },
  modules: [
    { name: "../application" },
    { name: "app/router" }
  ],
  optimize: "none"
})
