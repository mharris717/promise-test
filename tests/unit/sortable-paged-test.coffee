`import Ember from 'ember'`
`import Something from '../helpers/basic-helpers'`
`import DivideIntoPages from '../helpers/divide-into-pages'`
`import Equals from '../helpers/equals'`

equalArray = Equals.equalArray

module 'Unit - Sortable Paged Array', 
  setup: ->
    Something()

Promise = Ember.RSVP.Promise

Num = (num) -> Ember.Object.create(num: num)
Num.A = (a) -> Ember.A(a.map (x) -> Num(x))

PagedArray = Ember.ArrayProxy.extend
  page: 1
  perPage: 2

  divideObj: ->
    c = @get('allContent') || @get('content')
    DivideIntoPages.create(perPage: @get('perPage'), all: c)

  arrangedContent: (->
    @divideObj().objsForPage(@get('page'))).property("content.@each","allContent.@each","page","perPage")

SortedInnerArray = Ember.ArrayProxy.extend Ember.SortableMixin, 
  sortPropertiesBinding: "parent.sortProperties"
  sortAscendingBinding: "parent.sortAscending"
  contentBinding: "parent.content"

SortablePagedArray = PagedArray.extend 
  sortProperties: ["num"]
  sortAscending: true

  allContent: (->
    SortedInnerArray.create(parent: this)).property()


test "basic", ->
  all = Num.A([1,5,2,4,3])
  paged = SortablePagedArray.create(content: all)
  equalArray paged, [1,2]

test "add to all", ->
  all = Num.A([1,5,2,4,3])

  paged = SortablePagedArray.create(content: all)
  equalArray paged, [1,2]

  all.pushObject(Num(0.5))

  equalArray paged, [0.5,1]
