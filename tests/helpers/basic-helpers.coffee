`import Ember from 'ember'`

# Ember.Test.registerHelper('shouldHaveElementWithCount',
#   function(app, selector, n, context) {
#     var el = findWithAssert(selector, context);
#     var count = el.length;
#     equal(n, count, 'found ' + count + ' times');
#   }
# );

c = ->
  Ember.Test.registerHelper "shouldBeThree", (app, n, context) ->
    equal n, 3

  forEachArray = (a) ->
    res = []
    a.forEach (obj) -> res.push(obj)
    res

  Ember.Test.registerHelper "equalArray", (app,a,b,context) ->
    a = forEachArray(a)
    b = forEachArray(b)

    equal a.length,b.length
    i = 0
    while i < a.length
      equal a[i],b[i]
      i += 1

c()

`export default c`