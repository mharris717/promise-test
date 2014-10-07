`import Ember from 'ember'`
`import Something from '../helpers/basic-helpers'`
`import DivideIntoPages from '../helpers/divide-into-pages'`
`import Equals from '../helpers/equals'`

equalArray = Equals.equalArray

module 'Unit - Filtered Paged Array', 
  setup: ->
    Something()

Promise = Ember.RSVP.Promise

Num = (num) -> Ember.Object.create(num: num)
Num.A = (a) -> Ember.A(a.map (x) -> Num(x))

FilteredArray = Ember.ArrayProxy.extend
  arrangedContent: (->
    res = []
    if @get('content')
      for obj in @get('content')
        res.push(obj) if obj%2 == 0
    res).property("content.@each")

PagedArray = Ember.ArrayProxy.extend
  page: 1
  perPage: 2

  divideObj: ->
    c = @get('allContent') || @get('content')
    DivideIntoPages.create(perPage: @get('perPage'), all: c)

  arrangedContent: (->
    @divideObj().objsForPage(@get('page'))).property("content.@each","allContent.@each","page","perPage")

FilteredInnerArray = FilteredArray.extend
  contentBinding: "parent.content"

FilteredPagedArray = PagedArray.extend 
  allContent: (->
    FilteredInnerArray.create(parent: this)).property()


test "basic", ->
  all = [1,2,3,4,5,6,7,8,9,10]
  paged = FilteredPagedArray.create(content: all)
  equalArray paged, [2,4]

test "insert", ->
  all = Ember.A([1,2,3,4,5,6,7,8,9,10])
  paged = FilteredPagedArray.create(content: all)
  equalArray paged, [2,4]

  all.insertAt(0,12)
  equalArray paged, [12,2]

test "change", ->
  all = Ember.A([1,2,3,4,5,6,7,8,9,10])
  paged = FilteredPagedArray.create(content: all)
  equalArray paged, [2,4]

  all.removeAt(3)
  equalArray paged, [2,6]


FilteredArrayMixin = Ember.Mixin.create
  allContent: (->
    FilteredInnerArray.create(parent: this)).property()

FilteredMixinPagedArray = PagedArray.extend(FilteredArrayMixin)

test "with mixin", ->
  all = [1,2,3,4,5,6,7,8,9,10]
  paged = FilteredMixinPagedArray.create(content: all)
  equalArray paged, [2,4]