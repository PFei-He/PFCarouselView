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
![image](https://github.com/PFei-He/PFCarouselView/blob/master/PFCarouselView.gif)
