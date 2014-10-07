`import Ember from 'ember'`

Util = Ember.Object.extend()

Util.reopenClass
  find: (name,store,params,routeObj) ->
    if Pretender.findFunc
      Pretender.findFunc(name,store,params,routeObj)
    else
      store.find(name)

`export default Util`
