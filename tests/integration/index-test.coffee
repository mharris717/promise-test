`import startApp from '../helpers/start-app'`
`import pretenderServer from '../helpers/pretender-server'`
`import Ember from 'ember'`

Promise = Ember.RSVP.Promise

App = null
server = null

module 'Integration - Todo Index',
  setup: -> 
    App = startApp()
    server = pretenderServer()

  teardown: -> 
    Ember.run(App,'destroy')
    server.shutdown()

    Pretender.findFunc = null

test 'Should showo todos', ->
  Pretender.findFunc = (name,store,params) -> 
    new Promise (resolve,reject) ->
      resolve(store.find(name))
        
  visit("/todos").then ->
    equal find(".todo").length,3

test 'Should showo todos', ->
  Pretender.findFunc = (name,store,params) -> 
    new Promise (resolve,reject) ->
      store.find(name).then (res) ->
        resolve(res)

  visit("/todos").then ->
    equal find(".todo").length,3
