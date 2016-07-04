# littlelib

简单的javascript库, 基于原生对象的扩展, 兼容IE10/IE11/Chrome/Opera/Firefox/Safari等现代浏览器.适用于移动端.
<br>
尝试下jQuery-free吧!
<br>
> 依赖: [animate.css](http://daneden.github.io/animate.css/)

##安装方式
###bower:
````shell
bower install littlelib --save
````

###npm:
````shell
npm install littlelib --save
````
## 对象类型判断

getType(): 返回对象的类型(string, 小写)
<br>
isFunction(): 是否是函数
<br> 
isArray(): 是否是数组
<br>
isString(): 是否是字符串
<br>
isBoolean(): 是否是布尔值

## Dom操作

Q 等同于 document.querySelector
<br>
QA 等同于 document.querySelectorAll
<br> 
D 等同于 document.getElementById
<br>
CE 等同于 docuemnt.createElement

## Dom对象扩展

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

## ajax方法(queryData)

参数: url, data, method, callback, needJson 
<br>
默认post传递数据, method可以不写
<br>
回调callback的参数为后台响应数据, 默认转js对象字面量(json), 如果不需要请设置needJson为false
<br>
needJson默认为true



## (v0.0.4)2016年7月4日(for '74' in '74sharlock'!)

###在npm和bower上面都进行了注册, 现在可以分别使用bower和npm安装;
###做了umd模块化处理, 现在小库支持各种模块化应用.页面直接引用时, 部分方法位于window的lb对象下.基于原型的扩展方法未改变
````javascript
//es6
import lb from 'littlelib';

lb.isArray([]) //yes
lb.isBoolean(true) //yes


//or

import {isArray, isBoolean} from 'littelib';

isArray([]);
isBoolean(true);

//or

var lb = require('littlelib');

lb.isArray([]) //yes
lb.isBoolean(true) //yes

````

###类型检测增加了isNull, isUndefined, isEmpty, isNumber, isObject等方法, 其中isEmpty用于检测变量是否是空数组([])或空对象({})或空字符串('')

###移除了queryData方法, 现在由一个全新的名为ajax的方法代替. 除此之外还新增了一个ajaxAll的方法:
````javascript
import {ajax} from 'littlelib';

ajax('/api/xxx').query().then((data) =>{
    console.log(data);
});
````
不同的方法, 对应不同的请求类型:
  * query: [get]
  * save: [post]
  * update: [put]
  * remove: [delete]

除了query方法只有一个参数外, 其余方法均为两个参数, 第一个参数是传递的数据对象, 第二个参数是个boolean类型, 用于表示是否异步, 默认为异步:
````javascript
ajax('/api/xxx').save({id: 5}).then((data) =>{
    console.log(data);
});
````

ajax方法是多个异步请求同时发出, 全部结束时执行处理方法的解决方案, 避免了ajax回调方法的大坑:
````javascript
import {ajaxAll} from 'littlelib';

const urls = ['/api/users, /api/messages'];

ajaxAll(urls).done((dataList)=>{
    //dataList是一个数组, 每一项是和urls对应的数据
    let users = dataList[0], messages = dataList[1];
    console.log(users, messages);
});

````
要使用不同的请求方法时, 请求路径的每一项需要是一个对象, 格式为:

````javascript {path: 'xxx', method: 'post', data:{id:5}, async: true} ````

其中path为必须字段, method默认值为'get', async(是否异步)默认为true.

````javascript
const anotherUrls = [
    '/api/users',
    {
        path: '/api/messages',
        method: 'post',
        data:{id: 5, message: 'hello world!'}
    }
];

ajaxAll(anotherUrls).done((dataList)=>{
    console.log(dataList);
});

````



## (v0.0.3)8月17日更新:

### window下新增了一个R方法, 用于代替window.onload:
    //javascript
    R(function(){
        alert('这是一个方法.');
    });
    
    R(function(){
        alert('这是另一个方法.');
    });
    
    R(function(){
        alert('我们会在dom节点加载完成后立刻执行!');
    });


## (v0.0.2)8月4日更新:

### Element新增了一个contains方法, 用于检测一个节点是否包含另一节点:
    //html
    <div id="a">
        <div id="b" style="display:inline-block;">
            <i>^_^</i>
        </div>
    </div>

    //javascript
    var A = D('a'), B = D('b');
    console.log(A.contains(B)) // true

    A.on('click',function(e){
        var target = e.target;
        if(target === B || B.contains(target)){
            console.log('你肯定已经明白这种写法会用在什么地方.');
        }
    });

### Element新增了一个stopAnimation的方法, 用于停止元素正在进行的动画
    //html
    <div id="animator" style="width:10rem;height:10rem;background:lightseagreen;"></div>
    <button>start Animation</button>
    <button>stop Animation</button>

    //javascript
    var animator = D('animator'), playBtn = QA('button')[0], stopBtn = QA('button')[1];

    playBtn.on('click',function(){
       animator.animation({name:'fadeInRightBig', duration: 5}); //播放动画
    });

    stopBtn.on('click',function(){
        animator.stopAnimation();   //停止正在播放的动画
    });

