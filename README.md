PFCarouselView
==============

实现图片轮播功能

说明
-------------

PFCarouselView 是一款简单接入便可实现新闻客户端轮播图的开源库。开发者可使用代理或代码块的方式来对轮播图进行设置。本库具备扩展性好，使用简单，后期容易维护的特点。

代码展示
--------------

//创建一个轮播图<br>
carouselView = [[PFCarouselView alloc] initWithFrame:CGRectMake(0, 100, 320, 200) animationDuration:2 delegate:self];<br>

//设置页数<br>
[carouselView numberOfPagesInCarouselViewUsingBlock:^NSInteger(PFCarouselView *carouselView){
    return viewsArray.count;
}];<br>

//设置视图<br>
[carouselView contentViewAtIndexUsingBlock:^UIView *(PFCarouselView *carouselView, NSInteger index) {
    return viewsArray[index];
 }];<br>
 
运行效果展示
--------------


 
MIT License
--------------

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
