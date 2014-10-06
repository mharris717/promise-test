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
        success(@objsForPage(1))
      ,10

PagedRemoteArray = Ember.ArrayProxy.extend Ember.PromiseProxyMixin,
  page: 1
  perPage: 2

  store: null
  modelName: 'todo'

  setContent: ->
    promise = @store.find('todo', page: @get('page'))
    @set "promise", promise

  setPage: (page) ->
    @set 'page', page
    @setContent()


standardTest "route with paged array", 2, ->
  Pretender.findFunc = (name,realStore,params) -> 
    all = realStore.find(name)
    fakeStore = FakeStore.create(all: all)

    paged = PagedRemoteArray.create(store: fakeStore)
    paged.setPage params.page
    paged