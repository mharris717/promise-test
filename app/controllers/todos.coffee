`import Ember from 'ember'`

c = Ember.ArrayController.extend
  actions:
    save: ->
      @forEach (t) -> t.save()

`export default c`