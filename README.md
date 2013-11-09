Phantom-Robot-Proxy
===================

Phantom JS Proxy for Robot / Crawler

This is a Connect module for serve page for web crawler. It help you handling SEO setting with modern web application using hashtag / HTML5 history API. Phantom-Robot-Proxy will grab User-Agent from headers and rediect crawler request to phantomjs with redis cache.

## Requirement
* PhantomJS 1.6 or higher
* Redis Server 2.6 or higher
* Node Modules:
  * node-phantom
  * redis

## Usage

```
phantomProxy = require('phantomProxy')
// Express App
app.use(phantomProxy.listen)
```

## Options

### Customerize User Agent Matcher

```
phantomProxy.setMatcher(/(googlebot|bingbot|baiduspider|slurp|bingpreview|msnbot)/gi)
```

## Improvement

* Add module Checker
