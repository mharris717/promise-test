parseStandardTestParams = (a1,a2) ->
  testFunc = null
  numTodos = 3

  if a2
    testFunc = a2
    numTodos = a1
  else
    testFunc = a1

  {testFunc: testFunc, numTodos: numTodos}

standardTest = (name,num,f) ->
  ops = parseStandardTestParams(num,f)

  test name, ->
    ops.testFunc()
    shouldHaveTodos ops.numTodos

`export default standardTest`