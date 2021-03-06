`import Ember from 'ember'`
`import Util from '../models/util'`

c = Ember.Route.extend
  model: (params) ->
    # @store.find 'todo'
    Util.find 'todo', @store, params, this

  actions: 
    refresh: ->
      @refresh()

`export default c`