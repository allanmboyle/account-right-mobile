// Require JS Configuration
// r.js must be located in the same directory
({
    appDir: "../tmp/assets/javascripts/unoptimized",
    baseUrl: "lib",
    dir: "../tmp/assets/javascripts/optimized",
    paths: {
        app: "../app",
        jquery: "jquery-1.8.3.min",
        jquerymobile: "jquery.mobile-1.2.0.min",
        underscore: "lodash-0.10.0.min",
        backbone: "backbone-0.9.9.min",
        text: "text-2.0.3"
    },
    shim: {
        "backbone": {
            "deps": [ "underscore", "jquery" ],
            "exports": "Backbone"
        }
    },
    modules: [{ name: "../application" }, { name: "app/router" }],
    optimize: "none"
})
