`import Ember from 'ember'`

module 'Integration - Todo Index'

Promise = Ember.RSVP.Promise

test 'smoke', ->
  equal 2,2

asyncTest 'dead simple promise success', ->
  promise = new Promise (fulfill,reject) ->
    fulfill("Hello")
    QUnit.start()

  promise.then (res) ->
    equal res, "Hello"

asyncTest 'calling fulfill outside the promise', ->
  fulfill = null
  promise = new Promise (f,reject) ->
    fulfill = f

  promise.then (res) ->
    equal res, "Hello"

  setTimeout ->
    fulfill "Hello"
    QUnit.start()
  , 10


