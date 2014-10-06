`import Ember from 'ember'`
`import Something from '../helpers/basic-helpers'`
`import DivideIntoPages from '../helpers/divide-into-pages'`
`import Equals from '../helpers/equals'`

equalArray = Equals.equalArray

module 'Unit - Paged Array', 
  setup: ->
    Something()

Promise = Ember.RSVP.Promise

test 'smoke', ->
  equal 2,2

PagedArray = Ember.ArrayProxy.extend
  page: 1
  perPage: 2

  divideObj: ->
    DivideIntoPages.create(perPage: @get('perPage'), all: @get('content'))

  arrangedContent: (->
    @divideObj().objsForPage(@get('page'))).property("content.@each","page","perPage")


test "basic", ->
  paged = PagedArray.create(content: [1,2,3,4,5])
  equalArray paged, [1,2]

test "change page", ->
  paged = PagedArray.create(content: [1,2,3,4,5])
  paged.set "page", 2
  equalArray paged, [3,4]

test "change all content", ->
  all = Ember.A([1,2,3,4,5])
  paged = PagedArray.create(content: all)
  equalArray paged, [1,2]

  all.insertAt(1,9)
  equalArray paged, [1,9]

test "change all content 2", ->
  all = Ember.A([1,2,3,4,5])
  paged = PagedArray.create(content: all, page: 2)
  equalArray paged, [3,4]

  all.insertAt(1,9)
  equalArray paged, [2,3]