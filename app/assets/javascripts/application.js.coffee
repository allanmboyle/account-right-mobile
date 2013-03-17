###
  This is a manifest file that'll be compiled into application.js, which will include all the files
  listed below.

  Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
  or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.

  It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
  the compiled file.

  WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
  GO AFTER THE REQUIRES BELOW.
###

require.config(
  baseUrl: "assets/lib"
  paths:
    app: "../app"
    jquery: "jquery-1.9.1.min"
    jquerymobile: "jquery.mobile-1.3.0.min"
    underscore: "lodash-0.10.0.min"
    backbone: "backbone-0.9.9.min"
    text : "text-2.0.3"

  # Sets the configuration for your third party scripts that are not AMD compatible
  shim:
    backbone:
      deps: [ "jquery", "underscore" ]
      exports: "Backbone"  # Attaches "Backbone" to Window
)

require([ "require", "jquery", "backbone", "underscore" ], (require, $, Backbone, _) ->
  # Register JQueryMobile configuration
  $(document).on("mobileinit", () ->
    # Disable jQuery Mobile Navigation
    $.mobile.ajaxEnabled = false
    $.mobile.linkBindingEnabled = false
    $.mobile.hashListeningEnabled = false
    $.mobile.pushStateEnabled = false
    # Show Loading Overlay during AJAX calls
    $(document).ajaxStart(() -> $.mobile.loading("show"))
    $(document).ajaxStop(() -> $.mobile.loading("hide"))
    # JQueryMobile must be loaded prior to the Backbone Views
    require([ "app/router" ], (AccountRightRouter) -> @router = new AccountRightRouter())
  )
  require([ "jquerymobile" ])
)
