`import startApp from '../helpers/start-app'`
`import pretenderServer from '../helpers/pretender-server'`
`import standardTest from '../helpers/standard-test'`
`import Ember from 'ember'`
`import DivideIntoPages from '../helpers/divide-into-pages'`
`import Equals from '../helpers/equals'`

Promise = Ember.RSVP.Promise

shouldHaveTodosAfter = (num, f) ->
  andThen(f)
  andThen ->
    equal find(".todo").length,num

App = null
server = null

module 'Integration - Paged Array',
  setup: -> 
    App = startApp()
    server = pretenderServer()

  teardown: -> 
    Ember.run(App,'destroy')
    server.shutdown()

    Pretender.findFunc = null

PagedArray = Ember.ArrayProxy.extend
  page: 1
  perPage: 2

  divideObj: ->
    DivideIntoPages.create(perPage: @get('perPage'), all: @get('content'))

  arrangedContent: (->
    @divideObj().objsForPage(@get('page'))).property("content.@each","page","perPage")

standardTest "route with paged array", 2, ->
  Pretender.findFunc = (name,store,params) -> 
    all = store.find(name)
    PagedArray.create(content: all)

test "change page", ->
  paged = null
  Pretender.findFunc = (name,store,params) -> 
    all = store.find(name)
    paged = PagedArray.create(content: all)

  shouldHaveTodos 2

  shouldHaveTodosAfter 1, ->
    paged.set "page", 2
    Equals.equalFails find(".todo").length, correct: 1, current: 0

test "add record to store", ->
  store = null
  Pretender.findFunc = (name,storeArg,params) -> 
    store = storeArg
    all = store.find(name)
    paged = PagedArray.create(content: all, page: 2)

  shouldHaveTodos 1

  shouldHaveTodosAfter 2, ->
    store.createRecord 'todo', name: 'Something', completed: false

