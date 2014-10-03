`import Ember from 'ember'`

module 'Integration - Todo Index'

Promise = Ember.RSVP.Promise

test 'smoke', ->
  equal 2,2

equalArray = (a,b) ->
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
    equal object.get('doubled'), "HelloHello"
    equal object.get('tripled'), "HelloHelloHello"


asyncTest 'in ArrayController', ->
  promise = new Promise (fulfill,reject) ->
    fulfill([1,2,3])
    QUnit.start()

  ArrayPromiseController = Ember.ArrayController.extend(Ember.PromiseProxyMixin)

  array = ArrayPromiseController.create(promise: promise)
  array.then (res) ->
    equalArray res, [1,2,3]
    equal array.get('length'), 3

