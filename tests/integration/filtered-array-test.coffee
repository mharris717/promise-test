`import startApp from '../helpers/start-app'`
`import pretenderServer from '../helpers/pretender-server'`
`import Ember from 'ember'`

Promise = Ember.RSVP.Promise

App = null
server = null

module 'Integration - Filtered Array',
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

parseStandardTestParams = (a1,a2) ->
  testFunc = null
  numTodos = 3

  if a2
    testFunc = a2
    numTodos = a1
  else
    testFunc = a1

  {testFunc: testFunc, numTodos: numTodos}


standardTest = (name,num,f) ->
  ops = parseStandardTestParams(num,f)

  test name, ->
    ops.testFunc()
    shouldHaveTodos ops.numTodos

equalFails = (actual,ops) ->
  equal actual, ops.current





FilteredArray = Ember.ArrayProxy.extend
  arrangedContent: (->
    content = @get('content')
    res = []
    if content
      content.forEach (obj) ->
        res.push(obj) if !obj.get('completed')
    res).property("content.@each")

standardTest "route with filtered array", 2, ->
  Pretender.findFunc = (name,store,params) -> 
    all = store.find(name)
    FilteredArray.create(content: all)





FilteredArray.reopen
  wrappingPromise: ->
    new Promise (success,failure) =>
      @get('content').then (res) =>
        success(this)

standardTest "route with filtered array - wrapping promise", 2, ->
  Pretender.findFunc = (name,store,params) -> 
    all = store.find(name)
    FilteredArray.create(content: all).wrappingPromise()




FilteredPromiseDumbArray = FilteredArray.extend Ember.PromiseProxyMixin

# does not return properly filtered array
standardTest "route with filtered array", 3, ->
  Pretender.findFunc = (name,store,params) -> 
    all = store.find(name)
    FilteredPromiseDumbArray.create(promise: all)





FilteredPromiseArray = FilteredPromiseDumbArray.extend
  then: (success,failure) ->
    @get('promise').then (res) =>
      @set "content", res
      @get('arrangedContent')
      success(this)

# does not return properly filtered array
standardTest "route with filtered array", 2, ->
  Pretender.findFunc = (name,store,params) -> 
    all = store.find(name)
    FilteredPromiseArray.create(promise: all)
