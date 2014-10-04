`import Todo from '../../models/todo'`

# assumes always logged in as user 1
todos = -> Todo.FIXTURES

c = ->
  server = new Pretender ->
    @get "/todos", (request) ->
      res = {todos: todos()}
      
      [200, {"Content-Type": "application/json"}, JSON.stringify(res)]

`export default c`