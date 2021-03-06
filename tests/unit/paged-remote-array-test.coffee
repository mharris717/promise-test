`import Ember from 'ember'`
`import Something from '../helpers/basic-helpers'`
`import DivideIntoPages from '../helpers/divide-into-pages'`
`import Equals from '../helpers/equals'`

equalArray = Equals.equalArray

module 'Unit - Paged Remote Array', 
  setup: ->
    Something()

Promise = Ember.RSVP.Promise

test 'smoke', ->
  equal 2,2

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

PagedRemoteArray = Ember.ArrayProxy.extend
  perPage: 2

  store: null
  modelName: 'todo'

  init: ->
    @setContent()

  setContent: ->
    promise = @store.find('todo', page: @get('page'))
    promise.then (res) =>
      @set 'content', res
    promise

  setPage: (page) ->
    @set 'page', page
    @setContent()

asyncTest "thing", ->
  all = [1,2,3,4,5]
  store = FakeStore.create(all: all)
  paged = PagedRemoteArray.create(store: store)

  promise = paged.setPage 1

  promise.then ->
    QUnit.start()
    equalArray paged, [1,2]

PagedRemotePromiseArray = PagedRemoteArray.extend Ember.PromiseProxyMixin, 
  setContent: ->
    promise = @store.find('todo', page: @get('page'))
    @set "promise", promise

  setPage: (page) ->
    @set 'page', page

  pageObserver: (-> 
    if @get('page')
      @setContent()).observes("page")

asyncTest "can hook onto PagedRemoteArray#then", ->
  all = [1,2,3,4,5]
  store = FakeStore.create(all: all)
  paged = PagedRemotePromiseArray.create(store: store, page: 2)

  paged.then ->
    QUnit.start()
    equalArray paged, [3,4]

asyncTest "content doesn't update until new content is present", ->
  all = [1,2,3,4,5]
  store = FakeStore.create(all: all)
  paged = PagedRemotePromiseArray.create(store: store, page: 1)

  equalArray paged, []

  paged.then ->
    QUnit.start()
    equalArray paged, [1,2]

asyncTest "content doesn't update until new content is present - page change", ->
  all = [1,2,3,4,5]
  store = FakeStore.create(all: all)
  paged = PagedRemotePromiseArray.create(store: store, page: 1)

  paged.then ->
    equalArray paged, [1,2]

    paged.setPage 2
    equalArray paged, [1,2]

    paged.then ->
      QUnit.start()
      equalArray paged, [3,4]

