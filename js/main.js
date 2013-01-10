require.config({
    // 3rd party script alias names (Easier to type "jquery" than "libs/jquery-1.8.2.min")
    paths: {
        // Core Libraries
        "jquery": "libs/jquery-1.8.3.min",
        "jquerymobile": "libs/jquery.mobile-1.2.0.min",
        "underscore": "libs/lodash-0.10.0.min",
        "backbone": "libs/backbone-0.9.9.min"
    },
    // Sets the configuration for your third party scripts that are not AMD compatible
    shim: {
        "backbone": {
            "deps": [ "underscore", "jquery" ],
            "exports": "Backbone"  //attaches "Backbone" to the window object
        }
    } // end Shim Configuration
});

require([ "jquery", "backbone", "router", "jquerymobile" ], function($, Backbone, AccountRightRouter) {
    // Prevents all anchor click handling
    $.mobile.linkBindingEnabled = false;
    // Disabling this will prevent jQuery Mobile from handling hash changes
    $.mobile.hashListeningEnabled = false;
    // Instantiates a new Backbone.js Mobile Router
    this.router = new AccountRightRouter();
});
