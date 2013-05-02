Developer Notes
===============

Dependencies
------------

Runtime:
* Ruby = 1.9.3

Build:
* Runtime
* Node.JS >= 0.8.17
* PhantomJS >= 1.8 (unit testing dependency)
* jsl (metrics check dependency)
* Firefox (acceptance testing dependency - default browser)

Client Web App:
* Backbone 0.9.9
* JQuery Mobile 1.3
* RequireJS 2.1.4
* JQuery 1.9.1

Non-MYOB Developer Instructions
-------------------------------

In order to run the application remove the account-right-mobile-configuration entry in the Gemfile

Simon's Command Cheat Sheet
---------------------------

Rake Tasks:
* Acceptance tests without starting servers: ```rake acceptance:ok```
* Run app server with no caching, port 3000: ```rails s```
* Others:

```rake assets:clean```
```rake servers:stop```
```rake servers:start```
```rake commit acceptance:ok```

Jasmine tests:
* Via PhantomJS: ```rake jasmine```
* Via browser: ```rake jasmine:browser```

API Stub:
http://localhost:3003/stubs/aliases
http://localhost:3003/grant_access
http://localhost:3003/unavailable

OAuth Stub:
http://localhost:3002/stubs/aliases
http://localhost:3002/grant_access
http://localhost:3002/unavailable

Application server:
http://localhost:3000 (when started via ```rails s```)
http://localhost:3001 (when started via ```servers:start```)

License
=======

This application is licensed under the [GNU General Public License, version 3 (GPL-3.0) License](http://www.gnu.org/licenses/gpl-3.0.html)
