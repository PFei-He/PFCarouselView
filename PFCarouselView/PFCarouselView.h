//
//  PFCarouselView.h
//  PFCarouselView
//
//  Created by PFei_He on 14-10-24.
//  Copyright (c) 2014年 PF-Lib. All rights reserved.
//
//  https://github.com/PFei-He/PFCarouselView
//
//  vesion: 0.7.0
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
#import "PFConfigure.h"

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

///是否显示页控制器（白点），默认为显示
@property (nonatomic, assign)               BOOL                        pageControlShow;

///页控制器（白点）
@property (nonatomic, strong, readonly)     UIPageControl               *pageControl;

///是否显示文本，默认为显示
@property (nonatomic, assign)               BOOL                        textLabelShow;

///文本
@property (nonatomic, strong, readonly)     UILabel                     *textLabel;

///文本内容
@property (nonatomic, strong)               NSString                    *textString;

///文本边距
@property (nonatomic, assign)               UIEdgeInsets                textInsets;

///时间间隔
@property (nonatomic, assign)               NSTimeInterval              duration;

///代理
@property (nonatomic, weak)                 id<PFCarouselViewDelegate>  delegate;

/**
 *  @brief 停止滚动
 *  @detail 永远停止滚动
 */
- (void)stop;

/**
 *  @brief 暂停滚动
 *  @detail 手动翻页后滚动自动恢复
 */
- (void)pause;

/**
 *  @brief 恢复滚动
 *  @detail 初始化定义的时间后恢复
 */
- (void)resume;

/**
 *  @brief 刷新
 *  @detail 视图回滚到第一页
 */
- (void)refresh;

/**
 *  @brief 移除
 *  @detail 建议使用于视图控制器类的`- (void)viewWillDisappear:(BOOL)animated{}`或`- (void)viewDidDisappear:(BOOL)animated{}`
 *  @warning 当离开视图所在的视图控制器时必须要移除，否者会造成内存无法释放
 */
- (void)remove;

#pragma mark -

/**
 *  @brief 滚动视图总页数（使用块方法时必须执行该方法）
 *  @return 总页数
 */
- (void)numberOfPagesUsingBlock:(NSInteger(^)(void))block;

/**
 *  @brief 添加内容视图（使用块方法时必须执行该方法）
 *  @param index: 视图序号
 *  @return 内容视图
 */
- (void)setupContentViewUsingBlock:(UIView *(^)(NSInteger index))block;

/**
 *  @brief 设置页控制器（白点）
 *  @param pageControl: 页控制器（白点）
 *  @param index: 页控制器（白点）序号
 */
- (void)resetPageControlUsingBlock:(void(^)(UIPageControl *pageControl, NSInteger index))block;

/**
 *  @brief 设置文本
 *  @param textLabel: 文本
 *  @param index: 文本序号
 */
- (void)resetTextLabelUsingBlock:(void(^)(UILabel *textLabel, NSInteger index))block;

/**
 *  @brief 实现点击事件
 *  @param index: 点击事件序号
 */
- (void)didSelectViewUsingBlock:(void(^)(NSInteger index))block;

@end
