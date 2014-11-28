PFCarouselView
==============

>实现一个简单的图片轮播
![gif](https://github.com/tasselx/PFCarouselView/blob/master/Untitled.gif)
#Useage
``` 
//创建一个轮播图
    PFCarouselView *carouselView = [[PFCarouselView alloc] initWithFrame:CGRectMake(0, 100, 320, 200) animationDuration:2 delegate:self];

    //轮播图的背景
    carouselView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
    /*
    //设置页数
    [carouselView numberOfPagesInCarouselViewUsingBlock:^NSInteger(PFCarouselView *carouselView){
        return 5;
    }];

    //设置视图
    [carouselView contentViewAtIndexUsingBlock:^UIView *(PFCarouselView *carouselView, NSInteger index) {
        return viewsArray[index];
    }];

    //设置文本
    [carouselView textLabelAtIndexUsingBlock:^void (PFCarouselView *carouselView, UILabel *textLabel, NSInteger index) {
        textLabel.text = textArray[index];
        NSLog(@"%d", index);
    }];

    //设置点击事件
    [carouselView didSelectViewAtIndexUsingBlock:^(PFCarouselView *carouselView, NSInteger index) {
        NSLog(@"点击了第%d个", index);
    }];
     */
    [self.view addSubview:carouselView];

```
===========
###PFCarouselViewDelegate
```
//设置页数
- (NSInteger)numberOfPagesInCarouselView:(PFCarouselView *)automaticScrollView
{
    return 5;
}

//设置视图
- (UIView *)carouselView:(PFCarouselView *)carouselView contentViewAtIndex:(NSInteger)index
{
    return viewsArray[index];
}

//设置文本
- (void)carouselView:(PFCarouselView *)carouselView textLabel:(UILabel *)textLabel atIndex:(NSInteger)index
{
    textLabel.text = textArray[index];
}

//设置点击事件
- (void)carouselView:(PFCarouselView *)carouselView didSelectViewAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%d个", index);
}
```
