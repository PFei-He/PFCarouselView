//
//  PFCarouselView.m
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

#import "PFCarouselView.h"

@interface NSTimer (PFCarouselView)

/**
 *  @brief 暂停计时器
 */
- (void)pause;

/**
 *  @brief 恢复计时器
 */
- (void)resume;

/**
 *  @brief 恢复计时器的间隔时长
 */
- (void)resumeAfterTimeInterval:(NSTimeInterval)timeInterval;

@end

@implementation NSTimer (PFCarouselView)

//暂停计时器
- (void)pause
{
    //假如计时器无效则返回
    if (![self isValid]) return;

    //设置计时器运行时间为未来时间，则暂停了计时器
    [self setFireDate:[NSDate distantFuture]];
}

//恢复计时器
- (void)resume
{
    //假如计时器无效则返回
    if (![self isValid]) return;

    //设置计时器运行时间为当前时间，则立即运行计时器
    [self setFireDate:[NSDate date]];
}

//恢复计时器的时间间隔
- (void)resumeAfterTimeInterval:(NSTimeInterval)timeInterval
{
    //假如计时器无效则返回
    if (![self isValid]) return;

    //设置计时器运行时间为指定的间隔时长
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
}

@end

@interface NRLabel : UILabel
@property (nonatomic) UIEdgeInsets textInsets;
@end

@implementation NRLabel

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    UIEdgeInsets insets = self.textInsets;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                    limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    
    return rect;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.textInsets)];
}

@end

typedef NSInteger (^numberOfPagesBlock)(void);
typedef UIView *(^contentViewBlock)(NSInteger);
typedef void (^pageControlBlock)(UIPageControl *, NSInteger);
typedef void (^textLabelBlock)(UILabel *, NSInteger);
typedef void (^tapBlock)(NSInteger);

@interface PFCarouselView () <UIScrollViewDelegate>
{
    NSInteger               currentPage;        //当前页的序号
    NSInteger               pagesCount;         //总页数
    NSMutableOrderedSet     *contentViews;      //内容视图
    NSTimer                 *timer;             //动画计时器
}

///滚动视图
@property (nonatomic, strong)   UIScrollView        *scrollView;

///获取页数
@property (nonatomic, copy)     numberOfPagesBlock  numberOfPagesBlock;

///内容视图
@property (nonatomic, copy)     contentViewBlock    contentViewBlock;

///页控制器（白点）
@property (nonatomic, copy)     pageControlBlock    pageControlBlock;

///文本
@property (nonatomic, copy)     textLabelBlock      textLabelBlock;

///点击事件
@property (nonatomic, copy)     tapBlock            tapBlock;

@end

@implementation PFCarouselView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupViews];
    }
    return self;
}

#pragma mark - Views Management

//设置视图
- (void)setupViews
{
    [self setupScrollView];     //滚动视图
    [self setupPageControl];    //页控制器（白点）
    [self setupTextLabel];      //文本
    [self setupAutolayout];
}

//设置滚动视图
- (void)setupScrollView
{
    if (!_scrollView) _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.contentMode = UIViewContentModeCenter;
    _scrollView.contentSize = CGSizeMake(((pagesCount > 2) ? 3 : pagesCount) * CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    _scrollView.delegate = self;
    _scrollView.contentOffset = CGPointMake((pagesCount > 2) ? CGRectGetWidth(_scrollView.frame) : 0, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    if (pagesCount <= 2) {
        _scrollView.alwaysBounceHorizontal = YES;
    }
    [self addSubview:_scrollView];
}

//设置页控制器（白点）
- (void)setupPageControl
{
    if (!_pageControl) _pageControl = [[UIPageControl alloc] init];
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_pageControl];
}

//设置文本
- (void)setupTextLabel
{
    if (!_textLabel) _textLabel = [[NRLabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.size.height - 30, self.bounds.size.width, 30)];
    _textLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_textLabel];
}

- (void)setupAutolayout {
    UIView *superView = self;
    UIView *scrollView = _scrollView;
    UIView *pageControl = _pageControl;
    UIView *textLabel = _textLabel;
    
    superView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *views = NSDictionaryOfVariableBindings(superView,scrollView,pageControl,textLabel);
    // Scroll View
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views]];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views]];
    // PageControl & Label
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageControl]|" options:0 metrics:nil views:views]];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textLabel]|" options:0 metrics:nil views:views]];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pageControl][textLabel]|" options:0 metrics:nil views:views]];
}

//设置计时器
- (void)setupAnimationTimerWithDuration:(NSTimeInterval)animationDuration
{
    if (animationDuration > 0.0f) {
        if (!timer) timer = [NSTimer scheduledTimerWithTimeInterval:animationDuration target:self selector:@selector(animationTimerDidFired) userInfo:nil repeats:YES];
        [self run];
    }
}

//设置内容页
- (void)setupContentView
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewDataSource];

    //计数器
    NSInteger counter = 0;

    for (UIView *contentView in contentViews) {//设置内容页（遍历每一页的内容）
        //打开用户交互
        contentView.userInteractionEnabled = YES;

        //添加点击事件
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [contentView addGestureRecognizer:recognizer];

        //设置内容尺寸和位移
        CGRect frame = contentView.frame;
        frame.origin = CGPointMake(CGRectGetWidth(_scrollView.frame) * (counter++), 0);
        contentView.frame = frame;
        [_scrollView addSubview:contentView];
    }
    [_scrollView setContentOffset:(pagesCount > 2) ? CGPointMake(CGRectGetWidth(_scrollView.frame), 0) : CGPointZero];
}

//开始滚动
- (void)run
{
    //获取页数
    self.delegate?
    [self setPagesCount:[self.delegate numberOfPagesInCarouselView:self]]:
    self.numberOfPagesBlock?
    [self setPagesCount:self.numberOfPagesBlock()]:
    
    //暂停计时器
    [timer pause];
}

#pragma mark - Property Methods

//是否显示页控制器（白点）的setter方法
- (void)setPageControlShow:(BOOL)pageControlShow
{
    _pageControlShow = pageControlShow;
    _pageControl.hidden = !_pageControlShow;
}

//是否显示文本的setter方法
- (void)setTextLabelShow:(BOOL)textLabelShow
{
    _textLabelShow = textLabelShow;
    _textLabel.hidden = !_textLabelShow;
    _textLabel.text = textLabelShow ? _textString : nil;
    ((NRLabel *)_textLabel).textInsets = textLabelShow ? _textInsets : UIEdgeInsetsZero;
}

- (void)setTextString:(NSString *)textString {
    _textString = textString;
    _textLabel.text = textString;
}

- (void)setTextInsets:(UIEdgeInsets)textInsets {
    _textInsets = textInsets;
    ((NRLabel *)_textLabel).textInsets = textInsets;
}

#pragma mark - Private Methods

//设置总页数
- (void)setPagesCount:(NSInteger)count
{
    if ((pagesCount = count) > 0) {
        [self setupContentView];
        //恢复计时器（指定时间间隔后恢复）
        [timer resumeAfterTimeInterval:_duration];
    }

    //设置页控制器（白点）的总数
    _pageControl.numberOfPages = count;
    
    _scrollView.contentSize = CGSizeMake(((pagesCount > 2) ? 3 : pagesCount) * CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
}

//设置滚动视图的数据源
- (void)setScrollViewDataSource
{
    //设置内容页数组
    if (contentViews == nil) contentViews = [NSMutableOrderedSet new]; [contentViews removeAllObjects];

    //添加内容页
    self.delegate?
    ((pagesCount > 2 ) ? [contentViews addObject:[self.delegate carouselView:self setupContentViewAtIndex:[self getPage:currentPage - 1]]] : nil,
     [contentViews addObject:[self.delegate carouselView:self setupContentViewAtIndex:currentPage]],
     [contentViews addObject:[self.delegate carouselView:self setupContentViewAtIndex:[self getPage:currentPage + 1]]]):
    ((pagesCount > 2 ) ? [contentViews addObject:self.contentViewBlock([self getPage:currentPage - 1])] : nil,
     [contentViews addObject:self.contentViewBlock(currentPage)],
     [contentViews addObject:self.contentViewBlock([self getPage:currentPage + 1])]);
    
    kCALLBACK3(carouselView:, self, resetPageControl:, _pageControl, atIndex:, currentPage, self.pageControlBlock)
    kCALLBACK3(carouselView:, self, resetTextLabel:, _textLabel, atIndex:, currentPage, self.textLabelBlock)
}

//获取下一页的页数
- (NSInteger)getPage:(NSInteger)page
{
    /**
     *  p.s. 因为滚动视图的滚动数是从0开始，所以滚动数是总数-1
     */
    //如果传入的页数为-1，返回总页数-1（当前页为最后一页）
    if (page == -1) return pagesCount - 1;
    //如果传入的页数等于总页数，返回第0页（当前页为第一页）
    else if (page == pagesCount) return 0;
    //如果传入的页数不是第一页也不是最后一页，则当前页为此页
    else return page;
}

#pragma mark - Public Methods

//停止滚动
- (void)stop
{
    [timer invalidate], timer = nil;
}

//暂停滚动
- (void)pause
{
    [timer pause];
}

//恢复滚动
- (void)resume
{
    timer?
    [timer resumeAfterTimeInterval:_duration]:
    [self setupAnimationTimerWithDuration:_duration];
}

//刷新
- (void)refresh
{
    /**
     *  p.s. 因为滚动视图的滚动数是从0开始，所以当前页为0，其实是第一页
     */
    //设置页控制器（白点）当前页并设置当前页为第一页
    _pageControl.currentPage = (currentPage = 0);

    //开始滚动
    [self run];
}

//移除
- (void)remove
{
    [timer invalidate], timer = nil;
    [self removeFromSuperview];
}

#pragma mark -

kBLOCK1(numberOfPages, NSInteger, void, self.numberOfPagesBlock, if (self.contentViewBlock) [self setPagesCount:self.numberOfPagesBlock()])
kBLOCK1(setupContentView, UIView *, NSInteger, self.contentViewBlock, if (self.numberOfPagesBlock) [self setPagesCount:self.numberOfPagesBlock()])
kBLOCK1(didSelectView, void, NSInteger, self.tapBlock, nil)
kBLOCK2(resetPageControl, void, UIPageControl *, NSInteger, self.pageControlBlock, nil)
kBLOCK2(resetTextLabel, void, UILabel *, NSInteger, self.textLabelBlock, nil)

#pragma mark - Events Management

//计时器开始
- (void)animationTimerDidFired
{
    if (pagesCount <= 2) {
        return;
    }
    //设置位移
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + CGRectGetWidth(_scrollView.frame), 0) animated:YES];
}

//内容页被点击
- (void)tap
{
    kCALLBACK2(carouselView:, self, didSelectViewAtIndex:, currentPage, self.tapBlock)
}

#pragma mark - UIScrollViewDelegate

//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [timer pause];
}

//结束拖拽并且开始减速
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //恢复计时器（指定时间间隔后恢复）
    [timer resumeAfterTimeInterval:_duration];
}

//停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (pagesCount <= 2) {
        return;
    }
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

//滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (pagesCount > 2) {
        if(scrollView.contentOffset.x >= (2 * CGRectGetWidth(scrollView.frame))) {//翻到下一页
            currentPage = [self getPage:currentPage + 1];
            [self setupContentView];
        }
        if(scrollView.contentOffset.x <= 0) {//翻到上一页
            currentPage = [self getPage:currentPage - 1];
            [self setupContentView];
        }
    } else {
        currentPage = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    }

    //设置页控制器（白点）为当前页
    _pageControl.currentPage = currentPage;
}

@end
