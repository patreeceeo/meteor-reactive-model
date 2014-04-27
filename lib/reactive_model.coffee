class ReactiveModel

  defaults: {}

  _nextIdentifier: ->
    @constructor._instanceCount++
    "#{@constructor._instanceCount}"

  constructor: (@selector) ->
    @_dep = new Deps.Dependency
    @constructor._instanceCount = 0

    @collection = _.result this, 'collection'

    @_id =
      if _.isNumber(@selector)
        "#{@selector}"
      else if _.isString(@selector)
        @selector
      else
        @collection.findOne(@selector)?._id or Random.id()

  set: (first, second, third) ->
    if _.isObject(first)
      @_setMany first, second
    else
      @_setOne first, second, third

  _onUpsertComplete: (error, effectedCount, options) ->

  _upsert: (document, options = {}) ->
    callback = (error, effectedCount) =>
          @_onUpsertComplete(error, effectedCount, options)

    if @collection.findOne(@_id)? 
      @collection.update @_id, 
        $set: document, options, callback
    else
      @collection.insert _.defaults(_id: @_id, document), 
        options, callback

  _setMany: (hash, options) ->
    hash = _.omit hash, '_id'

    @_upsert hash, options

  _setOne: (key, value, options) ->
    hash = {}
    hash[key] = value

    @_upsert hash, options

  getAll: ->
    @_dep.depend()
    @collection.findOne(@_id)

  get: (key) ->
    @getAll()?[key]

  exists: ->
    @getAll()?

  select: (newSelector) ->
    unless EJSON.equals @selector, newSelector
      @selector = newSelector
      @_dep.changed()
      @_id =
        if _.isNumber(@selector)
          "#{@selector}"
        else if _.isString(@selector)
          @selector
        else
          @collection.findOne(@selector)?._id or Random.id()
    this

  remove: ->
    @collection.remove(@_id)





