`import Util from './util'`

DivideIntoPages = Ember.Object.extend
  perPage: 10

  objsForPage: (page) ->
    perPage = @get('perPage')
    s = (page-1)*perPage
    e = s + perPage - 1
    @get('all')[s..e]

  totalPages: ->
    allLength = parseFloat(@get('all.length'))
    perPage = parseFloat(@get('perPage'))

    res = (allLength+1.99) / perPage
    res = parseInt(res)
    res = 0 if allLength == 0

    Util.log "DivideIntoPages#totalPages, allLength #{allLength}, perPage #{perPage}, res #{res}"

    res

  range: (page) ->
    perPage = @get('perPage')
    s = (page-1)*perPage
    e = s + perPage - 1
    {start: s, end: e}

`export default DivideIntoPages`