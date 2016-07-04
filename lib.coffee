((root, factory)->
  if(typeof define is 'function' and define.amd)
    define ()->factory()
  else if typeof(module) isnt 'undefined'
    module.exports = factory()
  else
    root.lb = factory()
)(@, ()->
#工具区
  Q = document.querySelector.bind(document)
  D = document.getElementById.bind(document)
  QA = document.querySelectorAll.bind(document)
  CE = document.createElement.bind(document)
  R = (fn)->
    document.addEventListener 'DOMContentLoaded', fn, no

  noop = ()->

  getType = () ->
    l = arguments.length;
    arr = [];
    [].forEach.call(arguments, (arg)->
      arr.push(({}).toString.call(arg).replace(/\[object\s(.*)\]/,'$1').toLowerCase())
    )
    if l is 1 then arr[0] else arr;

  isString = (string)->
    getType(string) is 'string'

  isNumber = (number)->
    getType(number) is 'number'

  isBoolean = (bool)->
    getType(bool) is 'boolean'

  isObject = (object)->
    getType(object) is 'object'

  isFunction = (fn)->
    getType(fn) is 'function'

  isArray = (array)->
    getType(array) is 'array'

  isUndefined = (udfd)->
    getType(udfd) is 'undefined'

  isNull = (n)->
    getType(n) is 'null'

  isArray = (array)->
    getType(array) is 'array'

  isEmpty = (thing)->
    rule = {
      object: ()-> Object.keys(thing).length is 0
      string: ()->thing is ''
      array:  ()->thing.length is 0
      default: ()->no
    }
    type = if rule[getType(thing)] then getType(thing) else 'default';
    rule[type]();


#扩展区
  Element::on = (event, callback, capte) ->
    @addEventListener(event, callback, if isBoolean(capte) then capte else no)

  Element::off = (event, callback, capte) ->
    @removeEventListener(event, callback, if isBoolean(capte) then capte else no)

  Element::gas = Element::getAttribute

  Element::Q = (selector)->
    @querySelector(selector)

  Element::QA = (selector)->
    @querySelectorAll(selector)

  if not Element::contains
    Element::contains = (node) ->
      @compareDocumentPosition(node) > 19

  Element::removeClass = (className)->
    @classList.remove(className);
    @

  Element::stopAnimation = () ->
    if @isAnimating is yes
      @isAnimating = no
      @removeClass('animated')
      @removeClass(@animationName)
      @animationName = null
    @


  Element::addClass = (className)->
    @classList.add(className);
    @

  Element::toggleClass = (className)->
    @classList.toggle(className);
    @

  Element::hasClass = (selector)->
    @classList.contains(selector)

  Element::index = ->
    nodeName = @nodeName.toLowerCase()
    return i for item, i in @parentNode.querySelectorAll(nodeName) when @ is item

  Element::data = (name)->
    @gas('data-' + name)

  Element::animation = (opts) ->
    h = ()->
      @removeClass('animated')
      @removeClass(opts.name)
      @isAnimating = no
      @animationName = null
      if isFunction(opts.fn)
        opts.fn.call(@)
      @off('webkitAnimationEnd', h, no)
      @off('animationend', h, no)

    @on('webkitAnimationEnd', h, no)
    @on('animationend', h, no)

    @animationName = opts.name

    if getType(@animationName) is 'string'
      duration = opts.duration or 1
      delay = if getType(opts.delay) isnt 'number' then Number(opts.delay) else opts.delay
      count = opts.count or 1
      direction = opts.direction

      if not (getType(@isAnimating) is 'boolean')
        @isAnimating = no

      if not @isAnimating

        @isAnimating = yes

        if duration
          duration = duration + 's';
          @style.animationDuration = duration
          @style.webkitAnimationDuration = duration

        if delay
          delay = delay + 's';
          @style.animationDelay = delay
          @style.webkitAnimationDelay = delay

        if direction
          @style.animationDirection = direction
          @style.webkitAnimationDirection = direction

        if count
          @style.animationIterationCount = count
          @style.webkitAnimationIterationCount = count

        @addClass('animated')
        @addClass(opts.name)



  NodeList::on = (event, calback, capte)->
    elem.on(event, calback ,if isBoolean(capte) then capte else no) for elem in @
    @

  ajax = (url)->

    xhr = new XMLHttpRequest()
    resolveCallback = noop
    rejectCallback = noop;

    xhr.onload = ()-> resolveCallback and resolveCallback.apply(xhr, [if isString(xhr.responseText) then JSON.parse(xhr.responseText) else xhr.responseText]);

    xhr.onerror = ()->
    rejectCallback and rejectCallback.apply(xhr)

    sendData = (method, data, async)->
      thenFn = (fn)->
        resolveCallback = fn;

      failFn = (fn)->
        rejectCallback = fn

      dataString = '';

      xhr.open(method, url, if isBoolean(async) then async else yes);
      xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=UTF-8");

      if(data)
        for key in data
            val = data[key];
            dataString += String(key) + '=' + String(val) + '&';

        xhr.send(dataString);
      else
        xhr.send()

      {
        then: thenFn
        fail: failFn
      }

    {
      query: (async) -> sendData('get', async)
      save: (data, async) -> sendData('post', data, async);
      update: (data, async) -> sendData('put', data, async);
      remove: (data, async) -> sendData('delete', data, async)  
    }

  ajaxAll = (urls)->
    count = 0
    dataList = []
    resolveCallback = noop
    rejectCallback = noop

    done = (fn) -> resolveCallback = fn

    fail = (fn) -> rejectCallback = fn;

    urls.forEach((url, index) ->
      method = 'get'
      xhr = new XMLHttpRequest()

      if isObject(url)
        method = url.method;
        sendData = url.data;
        path = url.path;
        async = url.async;

      xhr.onload = () ->
        count = count + 1;
        dataList[index] = if isString(xhr.responseText) then JSON.parse(xhr.responseText) else xhr.responseText
        count is urls.length and resolveCallback and resolveCallback.apply(xhr, [dataList]);

      xhr.onerror = () -> rejectCallback && rejectCallback.apply(xhr, [url])

      xhr.open(method, path || url, if isBoolean(async) then async else yes);
      xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=UTF-8");

      if sendData
        dataString = ''
        for key in sendData
          val = sendData[key];
          dataString += String(key) + '=' + String(val) + '&'

        xhr.send(dataString);
      else
        xhr.send()
    )
    return {
      done: done
      fail: fail
    }

  return {
    Q
    D
    QA
    CE
    R
    noop
    getType
    isArray
    isBoolean
    isEmpty
    isFunction
    isNull
    isNumber
    isObject
    isString
    isUndefined
    ajax,
    ajaxAll
  };
);


