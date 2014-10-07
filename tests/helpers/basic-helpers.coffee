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

  Ember.Test.registerHelper "shouldHaveTodos", (app,num,context) ->
    visit("/todos").then ->
      equal find(".todo").length,num

  Ember.Test.registerHelper "shouldHaveTodosAfter", (app,num,f,context) ->
    andThen(f)
    andThen ->
      equal find(".todo").length,num

c()

`export default c`