[![Build Status](https://travis-ci.org/AlexRichter/MultiCurrency.png?branch=master)](https://travis-ci.org/AlexRichter/MultiCurrency)

# Multi Currency Plugin

## Alex's Build script

**This application must be built to run!**

To build this you need to have [Node.js](http://nodejs.org/) installed, once installed:

+   Open command prompt to directory
+   Run `npm install --dev`, this will install all project dependencies (including Grunt)
+   The application can then be built using grunt in two modes:
    +   `grunt debug` will build the application unminified and start a server on localhost:3000
        +   the application will automatically rebuild when a file in /plugin is changed, the browser can automatically reload these changes using the [LiveReload Plugin](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei?hl=en)
        +   the QUnit test suite is located at [/test.html](localhost:3000/test.html)
    +   `grunt dist` will build a minified version of the application in /dist which can be distributed