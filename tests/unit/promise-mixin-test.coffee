`import Ember from 'ember'`

module 'Integration - Todo Index'

Promise = Ember.RSVP.Promise

test 'smoke', ->
  equal 2,2

forEachArray = (a) ->
  res = []
  a.forEach (obj) -> res.push(obj)
  res

equalArray = (a,b) ->
  a = forEachArray(a)
  b = forEachArray(b)

  equal a.length,b.length
  i = 0
  while i < a.length
    equal a[i],b[i]
    i += 1

asyncTest 'in ObjectController', ->
  Greeting = Ember.Object.extend
    tripled: (->
      c = @get("content")
      "#{c}#{c}#{c}").property("content")

  promise = new Promise (fulfill,reject) ->
    greeting = Greeting.create(content: "Hello")
    fulfill(greeting)
    QUnit.start()

  ObjectPromiseController = Ember.ObjectController.extend Ember.PromiseProxyMixin, 
    doubled: (->
      c = @get("content.content")
      "#{c}#{c}").property("content")

  object = ObjectPromiseController.create(promise: promise)
  object.then (res) ->
    equal res.get('content'), "Hello"

    # property on root object is accessable
    equal object.get('doubled'), "HelloHello"

    # property on controller is accessable
    equal object.get('tripled'), "HelloHelloHello"



asyncTest 'in ArrayController', ->
  promise = new Promise (fulfill,reject) ->
    setTimeout ->
      fulfill([1,2,3])
      QUnit.start()
    , 5

  ArrayPromiseController = Ember.ArrayController.extend(Ember.PromiseProxyMixin)

  array = ArrayPromiseController.create(promise: promise)

  equal array.get('length'), 0
  array.forEach (obj) ->
    # do nothing

  array.then (res) ->
    equalArray res, [1,2,3]
    equal array.get('length'), 3


asyncTest 'in ArrayProxy', ->
  promise = new Promise (fulfill,reject) ->
    setTimeout ->
      fulfill([1,2,3])
      QUnit.start()
    , 5

  ArrayPromiseController = Ember.ArrayProxy.extend Ember.PromiseProxyMixin, 
    objectAtContent: (idx) ->
      @get('content')[idx] * 2

  array = ArrayPromiseController.create(promise: promise)

  equal array.get('length'), 0
  array.forEach (obj) ->
    # do nothing
  equal array.get('isPending'), true

  array.then (res) ->
    equalArray res, [1,2,3]
    equal array.get('length'), 3
    equalArray array, [2,4,6]

    equal array.get('isPending'), false
    equal array.get('isFulfilled'), true



