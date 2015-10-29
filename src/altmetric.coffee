# Description
#   Delivering freshly-baked Altmetric donuts for scholarly identifiers on demand.
#
# Commands:
#   hubot donut me IDENTIFIER - return a donut and details page for a scholarly
#                               identifier
#
# Author:
#   mudge

Promise = require 'pacta'

module.exports = (robot) ->
  getJSON = (url) ->
    promise = new Promise()
    robot.http(url).get() (err, res, body) ->
      if err
        promise.reject(err)
      else
        promise.resolve(JSON.parse(body))

    promise

  postJSON = (url, data) ->
    promise = new Promise()
    robot.http(url)
      .header('Content-Type', 'application/json')
      .post(JSON.stringify(data)) (err, res, body) ->
        if err
          promise.reject(err)
        else
          promise.resolve(JSON.parse(body))

    promise

  robot.respond /donut me (.+)$/i, (res) ->
    id = res.match[1]
    postJSON('http://api.altmetric.com/v1/translate', ids: id)
      .then (results) ->
        if results.hasOwnProperty(id)
          getJSON("http://api.altmetric.com/v1/id/#{ results[id] }?include_sections=images")
        else
          res.send 'Sorry, I couldn\'t find any altmetrics for that identifier.'
      .then(
        (citation) ->
          res.send "#{ citation.images.medium }#.png"
          res.send "http://www.altmetric.com/details/#{ citation.altmetric_id }"
        (error) ->
          res.send 'Sorry, I\'m struggling with the Altmetric API at the moment.'
      )
