`import startApp from '../helpers/start-app'`
`import pretenderServer from '../helpers/pretender-server'`
`import standardTest from '../helpers/standard-test'`
`import Ember from 'ember'`
`import DivideIntoPages from '../helpers/divide-into-pages'`
`import Equals from '../helpers/equals'`

Promise = Ember.RSVP.Promise
equalArray = Equals.equalArray

shouldHaveTodosAfter = (num, f) ->
  andThen(f)
  andThen ->
    equal find(".todo").length,num

App = null
server = null

module 'Integration - Paged Remote Array',
  setup: -> 
    App = startApp()
    server = pretenderServer()

  teardown: -> 
    Ember.run(App,'destroy')
    server.shutdown()

    Pretender.findFunc = null

FakeStore = Ember.Object.extend
  perPage: 2

  divideObj: ->
    DivideIntoPages.create(perPage: @get('perPage'), all: @get('all'))

  objsForPage: (page) ->
    @divideObj().objsForPage(page)

  find: (modelName, params) ->
    new Promise (success, failure) =>
      setTimeout =>
        page = params.page || 1
        success(@objsForPage(page))
      ,10

PagedRemoteArray = Ember.ArrayProxy.extend Ember.PromiseProxyMixin,
  init: ->
    @setContent()

  perPage: 2

  store: null
  modelName: 'todo'

  setContent: ->
    promise = @store.find('todo', page: @get('page'))
    @set "promise", promise

  setPage: (page) ->
    @set 'page', page

  pageObserver: (-> 
    if @get('page')
      @setContent()).observes("page")


standardTest "route with paged array", 2, ->
  Pretender.findFunc = (name,realStore,params) -> 
    all = realStore.find(name)
    fakeStore = FakeStore.create(all: all)

    PagedRemoteArray.create(store: fakeStore, page: params.page)

standardTest "route with paged array - page 2", 1, ->
  Pretender.findFunc = (name,realStore,params) -> 
    all = realStore.find(name)
    fakeStore = FakeStore.create(all: all)

    PagedRemoteArray.create(store: fakeStore, page: 2)

test "changing page", ->
  paged = null
  Pretender.findFunc = (name,realStore,params) -> 
    all = realStore.find(name)
    fakeStore = FakeStore.create(all: all)

    paged = PagedRemoteArray.create(store: fakeStore, page: params.page)

  visit("/todos").then ->
    equal find(".todo").length,2
    paged.setPage 2
    equal find(".todo").length,2

    paged.then ->
      # doesn't work
      # equal find(".todo").length,1

test "refresh test", ->
  route = null
  allParams = []

  pageParams = ->
    allParams.map (p) -> p.page || 1

  Pretender.findFunc = (name,realStore,params, r) -> 
    if !r
      throw "no route"

    params.page = params.page || 1
    route = r
    allParams.push(params)

    all = realStore.find(name)
    fakeStore = FakeStore.create(all: all)

    paged = PagedRemoteArray.create(store: fakeStore, page: params.page)

  visit("/todos").then ->
    equalArray pageParams(), [1]
    fillIn "#arbitrary-action input", "refresh"
    click("#arbitrary-action a")

  andThen ->
    equalArray pageParams(), [1,1]

    


