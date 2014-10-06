res = {}

forEachArray = (a) ->
  res = []
  a.forEach (obj) -> res.push(obj)
  res

res.equalArray = (a,b) ->
  a = forEachArray(a)
  b = forEachArray(b)

  equal "[#{a}]","[#{b}]"
  
  equal a.length,b.length
  i = 0
  while i < a.length
    equal a[i],b[i]
    i += 1

res.equalFails = (actual,ops) ->
  equal actual, ops.current

`export default res`