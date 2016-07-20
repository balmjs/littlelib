// Generated by CoffeeScript 1.10.0
(function() {
  (function(root, factory) {
    if (typeof define === 'function' && define.amd) {
      return define(function() {
        return factory();
      });
    } else if (typeof module !== 'undefined') {
      return module.exports = factory();
    } else {
      return root.lb = factory();
    }
  })(this, function() {
    var CE, D, Q, QA, R, ajax, ajaxAll, getType, isArray, isBoolean, isEmpty, isFunction, isNull, isNumber, isObject, isString, isUndefined, noop;
    Q = document.querySelector.bind(document);
    D = document.getElementById.bind(document);
    QA = document.querySelectorAll.bind(document);
    CE = document.createElement.bind(document);
    R = function(fn) {
      return document.addEventListener('DOMContentLoaded', fn, false);
    };
    noop = function() {};
    getType = function() {
      var arr, l;
      l = arguments.length;
      arr = [];
      [].forEach.call(arguments, function(arg) {
        return arr.push({}.toString.call(arg).replace(/\[object\s(.*)\]/, '$1').toLowerCase());
      });
      if (l === 1) {
        return arr[0];
      } else {
        return arr;
      }
    };
    isString = function(string) {
      return getType(string) === 'string';
    };
    isNumber = function(number) {
      return getType(number) === 'number';
    };
    isBoolean = function(bool) {
      return getType(bool) === 'boolean';
    };
    isObject = function(object) {
      return getType(object) === 'object';
    };
    isFunction = function(fn) {
      return getType(fn) === 'function';
    };
    isArray = function(array) {
      return getType(array) === 'array';
    };
    isUndefined = function(udfd) {
      return getType(udfd) === 'undefined';
    };
    isNull = function(n) {
      return getType(n) === 'null';
    };
    isArray = function(array) {
      return getType(array) === 'array';
    };
    isEmpty = function(thing) {
      var rule, type;
      rule = {
        object: function() {
          return Object.keys(thing).length === 0;
        },
        string: function() {
          return thing === '';
        },
        array: function() {
          return thing.length === 0;
        },
        "default": function() {
          return false;
        }
      };
      type = rule[getType(thing)] ? getType(thing) : 'default';
      return rule[type]();
    };
    Element.prototype.on = function(event, callback, capte) {
      return this.addEventListener(event, callback, isBoolean(capte) ? capte : false);
    };
    Element.prototype.off = function(event, callback, capte) {
      return this.removeEventListener(event, callback, isBoolean(capte) ? capte : false);
    };
    Element.prototype.gas = Element.prototype.getAttribute;
    Element.prototype.Q = function(selector) {
      return this.querySelector(selector);
    };
    Element.prototype.QA = function(selector) {
      return this.querySelectorAll(selector);
    };
    if (!Element.prototype.contains) {
      Element.prototype.contains = function(node) {
        return this.compareDocumentPosition(node) > 19;
      };
    }
    Element.prototype.removeClass = function(className) {
      this.classList.remove(className);
      return this;
    };
    Element.prototype.stopAnimation = function() {
      if (this.isAnimating === true) {
        this.isAnimating = false;
        this.removeClass('animated');
        this.removeClass(this.animationName);
        this.animationName = null;
      }
      return this;
    };
    Element.prototype.addClass = function(className) {
      this.classList.add(className);
      return this;
    };
    Element.prototype.toggleClass = function(className) {
      this.classList.toggle(className);
      return this;
    };
    Element.prototype.hasClass = function(selector) {
      return this.classList.contains(selector);
    };
    Element.prototype.index = function() {
      var i, item, j, len, nodeName, ref;
      nodeName = this.nodeName.toLowerCase();
      ref = this.parentNode.querySelectorAll(nodeName);
      for (i = j = 0, len = ref.length; j < len; i = ++j) {
        item = ref[i];
        if (this === item) {
          return i;
        }
      }
    };
    Element.prototype.data = function(name) {
      return this.gas('data-' + name);
    };
    Element.prototype.animation = function(opts) {
      var count, delay, direction, duration, h;
      h = function() {
        this.removeClass('animated');
        this.removeClass(opts.name);
        this.isAnimating = false;
        this.animationName = null;
        if (isFunction(opts.fn)) {
          opts.fn.call(this);
        }
        this.off('webkitAnimationEnd', h, false);
        return this.off('animationend', h, false);
      };
      this.on('webkitAnimationEnd', h, false);
      this.on('animationend', h, false);
      this.animationName = opts.name;
      if (getType(this.animationName) === 'string') {
        duration = opts.duration || 1;
        delay = getType(opts.delay) !== 'number' ? Number(opts.delay) : opts.delay;
        count = opts.count || 1;
        direction = opts.direction;
        if (!(getType(this.isAnimating) === 'boolean')) {
          this.isAnimating = false;
        }
        if (!this.isAnimating) {
          this.isAnimating = true;
          if (duration) {
            duration = duration + 's';
            this.style.animationDuration = duration;
            this.style.webkitAnimationDuration = duration;
          }
          if (delay) {
            delay = delay + 's';
            this.style.animationDelay = delay;
            this.style.webkitAnimationDelay = delay;
          }
          if (direction) {
            this.style.animationDirection = direction;
            this.style.webkitAnimationDirection = direction;
          }
          if (count) {
            this.style.animationIterationCount = count;
            this.style.webkitAnimationIterationCount = count;
          }
          this.addClass('animated');
          return this.addClass(opts.name);
        }
      }
    };
    NodeList.prototype.on = function(event, calback, capte) {
      var elem, j, len;
      for (j = 0, len = this.length; j < len; j++) {
        elem = this[j];
        elem.on(event, calback, isBoolean(capte) ? capte : false);
      }
      return this;
    };
    ajax = function(url, options) {
      var rejectCallback, resolveCallback, sendData, xhr;
      xhr = new XMLHttpRequest();
      resolveCallback = noop;
      rejectCallback = noop;
      xhr.onload = function() {
        return resolveCallback && resolveCallback.apply(xhr, [isObject(options) && options.needJson !== false ? JSON.parse(xhr.responseText) : xhr.responseText]);
      };
      xhr.onerror = function() {};
      rejectCallback && rejectCallback.apply(xhr);
      sendData = function(method, data, async) {
        var dataString, failFn, j, key, len, thenFn, val;
        thenFn = function(fn) {
          return resolveCallback = fn;
        };
        failFn = function(fn) {
          return rejectCallback = fn;
        };
        dataString = '';
        xhr.open(method, url, isBoolean(async) ? async : true);
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=UTF-8");
        if (data) {
          for (j = 0, len = data.length; j < len; j++) {
            key = data[j];
            val = data[key];
            dataString += String(key) + '=' + String(val) + '&';
          }
          xhr.send(dataString);
        } else {
          xhr.send();
        }
        return {
          then: thenFn,
          fail: failFn
        };
      };
      return {
        query: function(async) {
          return sendData('get', async);
        },
        save: function(data, async) {
          return sendData('post', data, async);
        },
        update: function(data, async) {
          return sendData('put', data, async);
        },
        remove: function(data, async) {
          return sendData('delete', data, async);
        }
      };
    };
    ajaxAll = function(urls) {
      var count, dataList, done, fail, rejectCallback, resolveCallback;
      count = 0;
      dataList = [];
      resolveCallback = noop;
      rejectCallback = noop;
      done = function(fn) {
        return resolveCallback = fn;
      };
      fail = function(fn) {
        return rejectCallback = fn;
      };
      urls.forEach(function(url, index) {
        var async, dataString, j, key, len, method, path, sendData, val, xhr;
        method = 'get';
        xhr = new XMLHttpRequest();
        if (isObject(url)) {
          method = url.method;
          sendData = url.data;
          path = url.path;
          async = url.async;
        }
        xhr.onload = function() {
          count = count + 1;
          dataList[index] = isString(xhr.responseText) ? JSON.parse(xhr.responseText) : xhr.responseText;
          return count === urls.length && resolveCallback && resolveCallback.apply(xhr, [dataList]);
        };
        xhr.onerror = function() {
          return rejectCallback && rejectCallback.apply(xhr, [url]);
        };
        xhr.open(method, path || url, isBoolean(async) ? async : true);
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=UTF-8");
        if (sendData) {
          dataString = '';
          for (j = 0, len = sendData.length; j < len; j++) {
            key = sendData[j];
            val = sendData[key];
            dataString += String(key) + '=' + String(val) + '&';
          }
          return xhr.send(dataString);
        } else {
          return xhr.send();
        }
      });
      return {
        done: done,
        fail: fail
      };
    };
    return {
      Q: Q,
      D: D,
      QA: QA,
      CE: CE,
      R: R,
      noop: noop,
      getType: getType,
      isArray: isArray,
      isBoolean: isBoolean,
      isEmpty: isEmpty,
      isFunction: isFunction,
      isNull: isNull,
      isNumber: isNumber,
      isObject: isObject,
      isString: isString,
      isUndefined: isUndefined,
      ajax: ajax,
      ajaxAll: ajaxAll
    };
  });

}).call(this);

//# sourceMappingURL=lib.js.map
