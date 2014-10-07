`import Ember from 'ember'`

c = Ember.ArrayController.extend
  actions:
    save: ->
      @forEach (t) -> t.save()

    triggerArbitraryAction: ->
      name = @get("arbitraryActionName")
      throw "no action" unless name
      @send(name)

`export default c`