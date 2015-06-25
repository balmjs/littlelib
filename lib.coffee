#工具区
window.Q = document.querySelector.bind(document)
window.D = document.getElementById.bind(document)
window.QA = document.querySelectorAll.bind(document)
window.CE = document.createElement.bind(document)

toString = Object::toString

window.getType = (everything) ->
	toString.call(everything).replace('[object ', '').replace(']', '').toLowerCase()

window.isFuction = (fn) ->
	getType(fn) is 'function'

window.isArray = (arr) ->
	getType(arr) is 'array'

window.isString = (string) ->
	getType(string) is 'string'

window.isBoolean = (boolean) ->
	getType(boolean) is 'boolean'

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

Element::removeClass = (className)->
	@classList.remove(className);
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
		if isFuction(opts.fn)
			opts.fn.call(@)
		@off('webkitAnimationEnd', h, no)
		@off('animationend', h, no)

	@on('webkitAnimationEnd', h, no)
	@on('animationend', h, no)

	if getType(opts.name) is 'string'
		duration = opts.duration or 1
		delay = if getType(opts.delay) is 'number' then opts.delay else 0
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

			if not (parseInt(count,10) is 1)
				@style.animationIterationCount = count
				@style.webkitAnimationIterationCount = count

			@addClass('animated')
			@addClass(opts.name)



NodeList::on = (event, calback, capte)->
	elem.on(event, calback ,if isBoolean(capte) then capte else no) for elem in @
	@

#ajax封装
window.queryData = (url, data, method, callback, needJson)->
	dataString = ''
	if toString.call(method) is '[object Function]'
		needJson = if isBoolean(callback) then callback else yes
		callback = method
		method = 'post'

	xhr = new XMLHttpRequest()

	xhr.onload = ->
		callback (if (isString(xhr.responseText) and needJson is yes) then JSON.parse(xhr.responseText) else xhr.responseText) if toString.call(callback) is '[object Function]'

	xhr.open(method, url, yes)
	xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded; charset=UTF-8");
	dataString += String(key) + '=' + String(val) + '&' for key, val of data
	xhr.send(dataString)

#ua检测 && 点击事件处理
window.isPhone = (->
	userAgent = navigator.userAgent;
	agents = ["Android", "iPhone", "SymbianOS", "Windows Phone", "iPad", "iPod"]
	flag = no
	l = agents.length
	while(l--)
		if userAgent.indexOf(agents[l]) > 0
			flag = yes
			break
	flag
)()

window.click = if isPhone then 'touchend' else 'click'


