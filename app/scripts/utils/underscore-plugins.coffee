_.mixin
  # Sorts an array by a sequence of comparison functions (of the type generally provided to
  # Array#sort. If the first function in the list of functions reports equality between two
  # elements will then use the next function in the sequence, then the next, and so on.
  multiSort: (arr, sortFns...) ->
    copy = arr.slice()
    copy.sort (a, b) ->
      for fn in sortFns
        return order if (order = fn(a, b)) isnt 0
      order

  # Concatenates the provided the array, and returns the result.
  concat: (arrays...) ->
    arr = []
    for a in arrays
      continue unless a?
      arr = arr.concat(a)
    arr

  # Nada, nothing, beans, bupkis
  noop: ->


# ~*~*~* DEBUGGING UTILITIES

wrap = (methodName) ->
  (name, fn) ->
    (args...) ->
      thisArg = @
      _[methodName](name, _.bind(fn, thisArg, args...))

_.mixin
  # Profiles immediately.
  profile: (nameOrFn, fn) ->
    if !fn
      fn = nameOrFn
      name = ''
    else
      name = nameOrFn

    try
      console.profile(name)
      fn()
    finally
      console.profileEnd(name)

  # Times the provided function, and returns the result.
  time: (name, fn) ->
    try
      console.time(name)
      fn()
    finally
      console.timeEnd(name)

  # Creates a new log group around the specified function
  logGroup: (name, fn) ->
    try
      console.group(name)
      fn()
    finally
      console.groupEnd(name)

  # Returns a function that will be profiled whenever invoked
  profiled: wrap('profile')

  # Returns a function that will be timed whenever invoked
  timed: wrap('time')

  # Returns a function that will be wrapped in a log group whenever invoked.
  logGrouped: wrap('logGroup')


  # ~*~*~* DIACRITICS

accentsFrom  = "ąàáäâãåæăćęèéëêìíïîłńòóöôõōøśșțùúüûñçżź"
accentsTo    = "aaaaaaaaaceeeeeiiiilnooooooosstuuuunczz"
accentsRegex = ///[#{accentsFrom}]///g
accentsMapping = _.object(_.zip(_.str.chars(accentsFrom), _.str.chars(accentsTo)))

_.mixin
  stripDiacritics: (str) ->
    str = String(str).toLowerCase().replace accentsRegex, (c) -> accentsMapping[c]
