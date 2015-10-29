Helper = require('hubot-test-helper')
nock = require('nock')
expect = require('chai').expect

helper = new Helper('../src/altmetric.coffee')

describe 'altmetric', ->
  beforeEach ->
    @room = helper.createRoom(http: false)

  afterEach ->
    @room.destroy()
    nock.cleanAll()

  context 'user asks for a donut with altmetrics', ->
    beforeEach (done) ->
      nock('http://api.altmetric.com')
        .get('/v1/translate/10.1629/2048-7754.79')
        .reply(200, { '10.1629/2048-7754.79': 1619179 })
        .get('/v1/id/1619179?include_sections=images')
        .reply(200, { altmetric_id: 1619179, images: { medium: 'http://donut/' } })
      @room.user.say 'alice', 'hubot donut me 10.1629/2048-7754.79'
      setTimeout done, 100

    it 'responds with a donut and details page link', ->
      expect(@room.messages).to.eql [
        ['alice', 'hubot donut me 10.1629/2048-7754.79'],
        ['hubot', 'http://donut/#.png'],
        ['hubot', 'http://www.altmetric.com/details/1619179']
      ]

  context 'user asks for donut with no altmetrics', ->
    beforeEach (done) ->
      nock('http://api.altmetric.com')
        .get('/v1/translate/10.1629/2048-7754.79')
        .reply(404, {})
      @room.user.say 'alice', 'hubot donut me 10.1629/2048-7754.79'
      setTimeout done, 100

    it 'responds with an error message', ->
      expect(@room.messages).to.eql [
        ['alice', 'hubot donut me 10.1629/2048-7754.79'],
        ['hubot', 'Sorry, I couldn\'t find any altmetrics for that identifier.']
      ]

  context 'users asks for donut when the Altmetric API is down', ->
    beforeEach (done) ->
      nock('http://api.altmetric.com')
        .get('/v1/translate/10.1629/2048-7754.79')
        .replyWithError('Jings me boab!')
      @room.user.say 'alice', 'hubot donut me 10.1629/2048-7754.79'
      setTimeout done, 100

    it 'responds with an error message', ->
      expect(@room.messages).to.eql [
        ['alice', 'hubot donut me 10.1629/2048-7754.79'],
        ['hubot', 'Sorry, I\'m struggling with the Altmetric API at the moment.']
      ]
