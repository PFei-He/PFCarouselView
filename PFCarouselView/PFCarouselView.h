//
//  PFCarouselView.h
//  PFCarouselView
//
//  Created by PFei_He on 14-10-24.
//  Copyright (c) 2014年 PF-Lib. All rights reserved.
//
//  https://github.com/PFei-He/PFCarouselView
//
//  vesion: 0.5.2
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

#import <UIKit/UIKit.h>

/**
 *  强弱引用转换，用于解决代码块（block）与强引用self之间的循环引用问题
 *  调用方式: `@weakify_self`实现弱引用转换，`@strongify_self`实现强引用转换
 *
 *  示例一：
 *  @weakify_self
 *  [obj block:^{
 *      weakSelf.property = something;
 *  }];
 *
 *  示例二（推荐使用，可防止对象被提前释放）：
 *  @weakify_self
 *  [obj block:^{
 *  @strongify_self
 *      self.property = something;
 *  }];
 */
#ifndef	weakify_self
    #if __has_feature(objc_arc)
        #define weakify_self autoreleasepool{} __weak __typeof__(self) weakSelf = self;
    #else
        #define weakify_self autoreleasepool{} __block __typeof__(self) blockSelf = self;
    #endif
#endif
#ifndef	strongify_self
    #if __has_feature(objc_arc)
        #define strongify_self try{} @finally{} __typeof__(weakSelf) self = weakSelf;
    #else
        #define strongify_self try{} @finally{} __typeof__(blockSelf) self = blockSelf;
    #endif
#endif

/**
 *  强弱引用转换，用于解决代码块（block）与强引用对象之间的循环引用问题
 *  调用方式: `@weakify(object)`实现弱引用转换，`@strongify(object)`实现强引用转换
 *
 *  示例：
 *  @weakify(object)
 *  [obj block:^{
 *      @strongify(object)
 *      strong_object = something;
 *  }];
 */
#ifndef	weakify
    #if __has_feature(objc_arc)
        #define weakify(object)	autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
    #else
        #define weakify(object)	autoreleasepool{} __block __typeof__(object) block##_##object = object;
    #endif
#endif
#ifndef	strongify
    #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) strong##_##object = weak##_##object;
    #else
        #define strongify(object) try{} @finally{} __typeof__(object) strong##_##object = block##_##object;
    #endif
#endif

@class PFCarouselView;

@protocol PFCarouselViewDelegate <NSObject>

/**
 *  @brief 滚动视图总页数
 *  @return 总页数
 */
- (NSInteger)numberOfPagesInCarouselView:(PFCarouselView *)carouselView;

/**
 *  @brief 添加内容视图
 *  @param index: 视图序号
 *  @return 内容视图
 */
- (UIView *)carouselView:(PFCarouselView *)carouselView setupContentViewAtIndex:(NSInteger)index;

@optional

/**
 *  @brief 设置页控制器（白点）
 *  @param pageControl: 页控制器（白点）
 *  @param index: 页控制器（白点）序号
 */
- (void)carouselView:(PFCarouselView *)carouselView resetPageControl:(UIPageControl *)pageControl atIndex:(NSInteger)index;

/**
 *  @brief 设置文本
 *  @param textLabel: 文本
 *  @param index: 文本序号
 */
- (void)carouselView:(PFCarouselView *)carouselView resetTextLabel:(UILabel *)textLabel atIndex:(NSInteger)index;

/**
 *  @brief 实现点击事件
 *  @param index: 点击事件序号
 */
- (void)carouselView:(PFCarouselView *)carouselView didSelectViewAtIndex:(NSInteger)index;

@end

@interface PFCarouselView : UIView

///时间间隔
@property (nonatomic, assign)               NSTimeInterval  duration;

///是否显示页控制器（白点），默认为显示
@property (nonatomic, assign)               BOOL            pageControlShow;

///页控制器（白点）
@property (nonatomic, strong, readonly)     UIPageControl   *pageControl;

///是否显示文本，默认为显示
@property (nonatomic, assign)               BOOL            textLabelShow;

///文本
@property (nonatomic, strong, readonly)     UILabel         *textLabel;

/**
 *  初始化滚动视图
 *  @param animationDuration: 自动滚动的间隔时长。如果<=0，不自动滚动
 *  @param delegate: 代理（不使用代理方法时设为nil）
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration delegate:(id<PFCarouselViewDelegate>)delegate;

/**
 *  @brief 停止滚动
 */
- (void)stop;

/**
 *  @brief 暂停滚动
 */
- (void)pause;

/**
 *  @brief 恢复滚动
 */
- (void)resume;

/**
 *  @brief 刷新
 */
- (void)refresh;

/**
 *  @brief 移除
 *  @warning 当离开视图所在的视图控制器时必须要移除，否者会因计时器不能释放而崩溃
 */
- (void)remove;

#pragma mark -

/**
 *  @brief 滚动视图总页数（使用块方法时必须执行该方法）
 *  @return 总页数
 */
- (void)numberOfPagesUsingBlock:(NSInteger (^)(PFCarouselView *carouselView))block;

/**
 *  @brief 添加内容视图（使用块方法时必须执行该方法）
 *  @param index: 视图序号
 *  @return 内容视图
 */
- (void)setupContentViewUsingBlock:(UIView *(^)(PFCarouselView *carouselView, NSInteger index))block;

/**
 *  @brief 设置页控制器（白点）
 *  @param pageControl: 页控制器（白点）
 *  @param index: 页控制器（白点）序号
 */
- (void)resetPageControlUsingBlock:(void (^)(PFCarouselView *carouselView, UIPageControl *pageControl, NSInteger index))block;

/**
 *  @brief 设置文本
 *  @param textLabel: 文本
 *  @param index: 文本序号
 */
- (void)resetTextLabelUsingBlock:(void (^)(PFCarouselView *carouselView, UILabel *textLabel, NSInteger index))block;

/**
 *  @brief 实现点击事件
 *  @param index: 点击事件序号
 */
- (void)didSelectViewUsingBlock:(void (^)(PFCarouselView *carouselView, NSInteger index))block;

@end
