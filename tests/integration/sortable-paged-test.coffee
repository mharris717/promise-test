`import startApp from '../helpers/start-app'`
`import pretenderServer from '../helpers/pretender-server'`
`import standardTest from '../helpers/standard-test'`
`import Ember from 'ember'`
`import DivideIntoPages from '../helpers/divide-into-pages'`
`import Equals from '../helpers/equals'`

Promise = Ember.RSVP.Promise
equalArray = Equals.equalArray

App = null
server = null

module 'Integration - Sortable Paged Array',
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
    c = @get('allContent') || @get('content')

    l = c.get('length')
    page = @get('page') || 1
    perPage = @get('perPage')
    console.debug "divideObj, c length #{l}, page #{page}, perPage #{perPage}"

    DivideIntoPages.create(perPage: @get('perPage'), all: c)

  arrangedContent: (->
    @divideObj().objsForPage(@get('page') || 1)).property("content.@each","allContent.@each","page","perPage","allContent.content.@each","allContent.arrangedContent.@each")

SortedInnerArray = Ember.ArrayProxy.extend Ember.SortableMixin, 
  sortPropertiesBinding: "parent.sortProperties"
  sortAscendingBinding: "parent.sortAscending"
  contentBinding: "parent.content"

SortablePagedArray = PagedArray.extend 
  sortProperties: ["name"]
  sortAscending: false

  allContent: (->
    SortedInnerArray.create(parent: this)).property()

ArrayProxyPromiseMixin = Ember.Mixin.create Ember.PromiseProxyMixin, 
  then: (f) ->
    promise = @get('promise')
    promise.then (res) =>
      f(this)

SortablePromisePagedArray = SortablePagedArray.extend ArrayProxyPromiseMixin

if false
  standardTest "sdfisdfisdf", 2, ->
    Pretender.findFunc = (name,realStore,params) -> 
      all = realStore.find(name)
      SortablePagedArray.create(content: all, page: params.page)

if true
  test "basic", ->
    Pretender.findFunc = (name,realStore,params) -> 
      all = realStore.find(name)
      res = SortablePromisePagedArray.create(promise: all, page: params.page)


    visit("/todos").then ->
      names = []
      for cell in find(".todo td.name")
        names.push(cell.innerText)

      equalArray names,['More Stuff','Make Dinner']




