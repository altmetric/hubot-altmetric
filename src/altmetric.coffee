# Description
#   Delivering freshly-baked Altmetric donuts for scholarly identifiers on demand.
#
# Commands:
#   hubot donut me <identifier> - return a donut and details page for a scholarly identifier
#
# Author:
#   mudge

Promise = require 'pacta'

module.exports = (robot) ->
  getJSON = (url) ->
    new Promise (resolve, reject) ->
      robot.http(url).get() (err, res, body) ->
        if err
          reject(err.message)
        else
          resolve(JSON.parse(body))

  postJSON = (url, data) ->
    new Promise (resolve, reject) ->
      robot.http(url)
        .header('Content-Type', 'application/json')
        .post(JSON.stringify(data)) (err, res, body) ->
          if err
            reject(err.message)
          else
            resolve(JSON.parse(body))

  robot.respond /donut me (.+)$/i, (res) ->
    id = res.match[1]
    postJSON('http://api.altmetric.com/v1/translate', ids: id)
      .then (results) ->
        if results.hasOwnProperty(id)
          getJSON("http://api.altmetric.com/v1/id/#{ results[id] }?include_sections=images")
        else
          throw "no altmetrics for #{id}"
      .then (citation) ->
        res.send "#{ citation.images.medium }#.png"
        res.send "http://www.altmetric.com/details/#{ citation.altmetric_id }"
      .catch (error) ->
        res.send "Sorry, I couldn't donut that for you: #{error}"
