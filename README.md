# littlelib
简单的javascript库, 基于原生对象的扩展, 兼容IE10/IE11/Chrome/Opera/Firefox/Safari等现代浏览器.适用于移动端.
<br>
尝试下jQuery-free吧!
<br>
> 依赖: [animate.css](http://daneden.github.io/animate.css/)

对象类型判断
------------
getType(): 返回对象的类型(string, 小写)
<br>
isFunction(): 是否是函数
<br> 
isArray(): 是否是数组
<br>
isString(): 是否是字符串
<br>
isBoolean(): 是否是布尔值

Dom操作
-------
Q 等同于 document.querySelector
<br>
QA 等同于 document.querySelectorAll
<br> 
D 等同于 document.getElementById
<br>
CE 等同于 docuemnt.createElement

Dom对象扩展
----------
    var div = D('div1');
    var h = function(){
      alert('ok');
    };

### 事件 (on, off)
    div.on('click', h);
    div.off('click', h);
    
    //如果对象是一个NodeList, 依然可以用, 针对NodeList也做了扩展, 会为list中的每一个元素绑定事件
    //但是请尽量避免使用这种方式, 以免过多监听影响性能
    var someDivs = QA('div');
    someDivs.on('click', h);
    someDivs.off('click', h);

### addClass && removeClass && toggleClass && hasClass
    //增加className
    div.addClass('active');
    //移除一个ClassName(目前只能一次移除一个)
    div.removeClass('active');
    //切换className
    div.toggleClass('active');
    //检查是否拥有某个ClassName
    if (div.hasClass('active')){
        //do something
    }
    
    //也可以用链式操作(hasClass返回的是布尔值)
    div.addClass('active').removeClass('active').toggleClass('active');

### 子元素查找

    var span = div.Q('span');       // span = div.querySelector('span')
    var spanList = div.QA('span');  // span = div.querySelectorAll('span')

### 属性操作(gas && data)
    var dataId = div.gas('data-id'); // elem.gas = elem.getAttribute
    //或者
    var dataId = div.data('id');
    //如果是类似'data-xxx-id'这种格式, 使用data('xxx-id'), 请不要写成驼峰
    //太懒了, 不想为一个'-'写几行代码, -_-
    

### animation方法(css3动画,配合[animate.css](http://daneden.github.io/animate.css/)使用)
    div.animation({
        name: '',              //animate.css 动画名称
        duration: 1.5,         //动画持续1.5s(如果不写默认为1s)
        delay: 1,              //延迟1s(默认为没有延迟)
        count: 2,              //动画播放2次 (也可以传字符串'infinite'无限播放)
        direction: 'normal',   //是否需要逆向播放 ('normal', 'alternate')
        fn:function(){
            console.log(this); //动画执行完毕时的回调, this指向当前Dom元素
        }
    });

ajax方法(queryData)
------------------
参数: url, data, method, callback, needJson 
<br>
默认post传递数据, method可以不写
<br>
回调callback的参数为后台响应数据, 默认转js对象字面量(json), 如果不需要请设置needJson为false
<br>
needJson默认为true




