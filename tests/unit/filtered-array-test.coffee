`import Ember from 'ember'`
`import Something from '../helpers/basic-helpers'`

module 'Unit - Filtered Array'

Promise = Ember.RSVP.Promise

test 'smoke', ->
  equal 2,2

simpleArrayPromise = ->
  new Promise (fulfill,reject) ->
    setTimeout ->
      fulfill([1,2,3,4,5])
      QUnit.start()
    , 5

FilteredArray = Ember.ArrayProxy.extend
  arrangedContent: (->
    res = []
    if @get('content')
      for obj in @get('content')
        res.push(obj) if obj%2 == 0
    res).property("content.@each")

FilteredDumbPromiseArray = FilteredArray.extend(Ember.PromiseProxyMixin)

test "basic", ->
  array = FilteredArray.create(content: [1,2,3,4,5])
  equalArray array, [2,4]

asyncTest 'promise mixin', ->
  promise = simpleArrayPromise()

  array = FilteredDumbPromiseArray.create(promise: promise)
  array.then (res) ->
    # the array is the filtered list
    equalArray array, [2,4]

    # the result returned in then is the unfiltered list
    equalArray res, [1,2,3,4,5]

FilteredPromiseArray = FilteredDumbPromiseArray.extend
  then: (success,failure) ->
    console.debug "in then"
    @get('promise').then (res) =>
      success(this)

asyncTest 'promise mixin', ->
  promise = simpleArrayPromise()

  array = FilteredPromiseArray.create(promise: promise)
  array.then (res) ->
    # the array is the filtered list
    equalArray array, [2,4]

    # the result returned in then is the filtered list
    equalArray res, [2,4]