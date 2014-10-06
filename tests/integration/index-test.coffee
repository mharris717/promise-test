`import startApp from '../helpers/start-app'`
`import pretenderServer from '../helpers/pretender-server'`
`import Ember from 'ember'`

Promise = Ember.RSVP.Promise

App = null
server = null

module 'Integration - Index',
  setup: -> 
    App = startApp()
    server = pretenderServer()

  teardown: -> 
    Ember.run(App,'destroy')
    server.shutdown()

    Pretender.findFunc = null

shouldHaveTodos = (num) ->
  visit("/todos").then ->
    equal find(".todo").length,num

standardTest = (name,num,f) ->
  if !f
    f = num
    num = 3
  test name, ->
    f()
    shouldHaveTodos num

standardTest 'Should showo todos', ->
  Pretender.findFunc = (name,store,params) -> 
    new Promise (resolve,reject) ->
      resolve(store.find(name))

standardTest 'Should showo todos', ->
  Pretender.findFunc = (name,store,params) -> 
    new Promise (resolve,reject) ->
      store.find(name).then (res) ->
        resolve(res)

standardTest 'Should showo todos', ->
  Pretender.findFunc = (name,store,params) -> 
    new Promise (resolve,reject) ->
      all = store.find(name)
      all.then (res) ->
        resolve(all)
