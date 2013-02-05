require.config(
  baseUrl: "/tmp/assets/javascripts/unoptimized/lib",
  paths:
    app: "../app",
    jquery: "jquery-1.8.3.min",
    jquerymobile: "jquery.mobile-1.2.0.min",
    underscore: "lodash-0.10.0.min",
    backbone: "backbone-0.9.9.min",
    text : "text-2.0.3"

  # Sets the configuration for your third party scripts that are not AMD compatible
  shim:
    backbone:
      deps: [ "underscore", "jquery" ],
      exports: "Backbone"  # Attaches "Backbone" to Window
)
