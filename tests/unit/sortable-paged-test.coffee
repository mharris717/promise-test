`import Ember from 'ember'`
`import Something from '../helpers/basic-helpers'`
`import DivideIntoPages from '../helpers/divide-into-pages'`
`import Equals from '../helpers/equals'`

equalArray = Equals.equalArray

module 'Unit - Sortable Paged Array', 
  setup: ->
    Something()

Promise = Ember.RSVP.Promise

PagedArray = Ember.ArrayProxy.extend
  page: 1
  perPage: 2

  divideObj: ->
    DivideIntoPages.create(perPage: @get('perPage'), all: @get('content'))

  arrangedContent: (->
    @divideObj().objsForPage(@get('page'))).property("content.@each","page","perPage")

SortedInnerArray = Ember.ArrayProxy.extend Ember.SortableMixin, 
  sortPropertiesBinding: "parent.sortProperties"
  sortAscendingBinding: "parent.sortAscending"
  contentBinding: "parent.content"

SortablePagedArray = PagedArray.extend 
  sortProperties: ["num"]
  sortAscending: true

  sortedContent: (->
    SortedInnerArray.create(parent: this)).property()

  divideObj: ->
    DivideIntoPages.create(perPage: @get('perPage'), all: @get('sortedContent'))

  arrangedContent: (->
    @divideObj().objsForPage(@get('page'))).property("content.@each","page","perPage","sortProperties","sortAscending")

  toNums: ->
    res = []
    @forEach (x) -> res.push(x.get('num'))
    res

test "basic", ->
  all = [1,5,2,4,3].map (x) -> Ember.Object.create(num: x)
  paged = SortablePagedArray.create(content: all)
  equalArray paged.toNums(), [1,2]
