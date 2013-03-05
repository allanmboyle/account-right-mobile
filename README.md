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

Client Web App
==============
JQuery 1.9.1
JQuery Mobile 1.3

Simon's Command Cheat Sheet
===========================
rake acceptance:ok			<--- Run without restarting the servers
rake assets:clean
rake servers:stop
rake servers:start
rails s 					<--- use this to start the servers in test mode (no caching). Port 3000.
rake commit acceptance:ok

The oAuth stub server:
http://localhost:3002/stubs/aliases
http://localhost:3002/grant_access
http://localhost:3002/unavailable
http://localhost:3001 		<--- The main app started with servers:start
http://127.0.0.1:8888/tmp/spec/javascripts/_SpecRunner.html

License
=======

This application is licensed under the [GNU General Public License, version 3 (GPL-3.0) License](http://www.gnu.org/licenses/gpl-3.0.html)
