redis = require('redis')
client = redis.createClient()
phantom = require('node-phantom')

matcher = /(googlebot|bingbot|baiduspider|slurp|bingpreview|msnbot)/gi

# Redis
client.on 'ready', ->
  console.info 'Redis Ready'
client.on 'error', (err)->
  console.error "Redis Error: #{err}"

requestPage = (url, res)->
  try
    client.get url, (err, html)->
      throw err if err
      
      # Serve with Redis Cache
      return res.end html if html?
    
      # Serve with PhantomJS
      phantom.create (err, ph)->
        throw err if err
        ph.createPage (err, page)->
          throw err if err
          page.open url, (err, status)->
            throw err if err
            page.evaluate ()->
              return {
                body: document.body.outerHTML
                head: document.head.outerHTML
              }
            , (err, result)->
              throw err if err
              html = "<!DOCTYPE html><html>#{result.head}#{result.body}</html>"
              
              # Cache to Redis
              client.set url, html, redis.print
              
              # Send to Crawler
              res.end html
  catch ex
    console.error ex
        

process.on 'exit', ->
  phantom.exit() for phantom in phantoms
  
exports.setMatcher = (newMatcher)->
  return false if newMatcher.constructor isnt RegExp
  matcher = newMatcher
  return true

exports.listen = (req, res, next)->
  if req.headers['user-agent'].match(matcher) isnt null
    requestPage "#{req.protocol}://#{req.host}#{req.path}", res
  else
    next()