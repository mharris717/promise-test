`import Ember from 'ember'`

Util = Ember.Object.extend()

Util.reopenClass
  find: (name,store,params) ->
    if Pretender.findFunc
      Pretender.findFunc(name,store,params)
    else
      store.find(name)

`export default Util`
