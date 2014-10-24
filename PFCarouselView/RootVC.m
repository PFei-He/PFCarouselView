//
//  RootVC.m
//  PFCarouselView
//
//  Created by PFei_He on 14-10-24.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import "RootVC.h"

@interface RootVC ()

@end

@implementation RootVC

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
    textArray = @[@"0", @"1", @"2", @"3", @"4"];

    //遍历视图
    for (int i = 0; i < colorArray.count; ++i) {
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        tempLabel.backgroundColor = [(UIColor *)[colorArray objectAtIndex:i] colorWithAlphaComponent:0.5];
        [viewsArray addObject:tempLabel];
    }

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
}

#pragma mark - PFCarouselViewDelegate

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

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
