//
//  Copyright (c) 2018 faylib.top
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "RootVC.h"

@interface RootVC ()

@end

@implementation RootVC

#pragma mark - View Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //视图数组
    viewsArray = [@[] mutableCopy];

    //视图背景颜色的数组
    NSArray *colorArray = @[[UIColor cyanColor], [UIColor blueColor], [UIColor greenColor], [UIColor yellowColor], [UIColor purpleColor]];
    textsArray = @[@"0", @"1", @"2", @"3", @"4"];

    //遍历视图
    for (int i = 0; i < colorArray.count; ++i) {
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        tempLabel.backgroundColor = [(UIColor *)[colorArray objectAtIndex:i] colorWithAlphaComponent:0.5];
        [viewsArray addObject:tempLabel];
    }

    //创建一个轮播图
    PFCarouselView *carouselView = [[PFCarouselView alloc] initWithFrame:CGRectMake(0, 100, 320, 200)];
    
    //设置时间间隔
    carouselView.duration = 2.0f;
    
    //设置代理
//    carouselView.delegate = self;
    
    //轮播图的背景
    carouselView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
/*
    //设置页数
    [carouselView numberOfPagesUsingBlock:^NSInteger{
        return viewsArray.count;
    }];
    
    //设置视图
    [carouselView setupContentViewUsingBlock:^UIView *(NSInteger index) {
        return viewsArray[index];
    }];

    //设置文本
    [carouselView resetTextLabelUsingBlock:^(UILabel *textLabel, NSInteger index) {
        textLabel.text = textsArray[index];
    }];

    //设置点击事件
    [carouselView didSelectViewUsingBlock:^(NSInteger index) {
        NSLog(@"点击了第%d个", index);
    }];
*/
    //开始滚动
    [carouselView resume];
    
    [self.view addSubview:carouselView];
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - PFCarouselViewDelegate Implementation

//设置页数
- (NSInteger)numberOfPagesInCarouselView:(PFCarouselView *)carouselView
{
    return viewsArray.count;
}

//设置视图
- (UIView *)carouselView:(PFCarouselView *)carouselView setupContentViewAtIndex:(NSInteger)index
{
    return viewsArray[index];
}

//设置文本
- (void)carouselView:(PFCarouselView *)carouselView resetTextLabel:(UILabel *)textLabel atIndex:(NSInteger)index
{
    textLabel.text = textsArray[index];
}

//设置点击事件
- (void)carouselView:(PFCarouselView *)carouselView didSelectViewAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%d个", index);
}

@end
