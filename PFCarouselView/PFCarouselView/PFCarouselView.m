//
//  PFCarouselView.m
//  PFCarouselView
//
//  Created by PFei_He on 14-10-24.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import "PFCarouselView.h"

@interface NSTimer (PFCarouselView)

/**
 *  @brief 暂停计时器
 */
- (void)pauseTimer;

/**
 *  @brief 恢复计时器
 */
- (void)resumeTimer;

/**
 *  @brief 恢复计时器的间隔时长
 */
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)timeInterval;

@end

@implementation NSTimer (PFCarouselView)

//暂停计时器
- (void)pauseTimer
{
    //假如计时器无效则返回
    if (![self isValid]) return;

    //设置计时器运行时间为未来时间，则暂停了计时器
    [self setFireDate:[NSDate distantFuture]];
}

//恢复计时器
- (void)resumeTimer
{
    //假如计时器无效则返回
    if (![self isValid]) return;

    //设置计时器运行时间为当前时间，则立即运行计时器
    [self setFireDate:[NSDate date]];
}

//恢复计时器的时间间隔
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)timeInterval
{
    //假如计时器无效则返回
    if (![self isValid]) return;

    //设置计时器运行时间为指定的间隔时长
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
}

@end

//获取总页数
typedef NSInteger (^numberOfPagesBlock)(PFCarouselView *);

//获取内容页
typedef UIView *(^contentViewBlock)(PFCarouselView *, NSInteger);

//页控制器（白点）
typedef void (^pageControlBlock)(PFCarouselView *, UIPageControl *, NSInteger);

//文本
typedef void (^textLabelBlock)(PFCarouselView *, UILabel *, NSInteger);

//点击事件
typedef void (^tapBlock)(PFCarouselView *, NSInteger);

@interface PFCarouselView () <UIScrollViewDelegate>
{
    NSInteger       currentPageIndex;   //当前页的序号
    NSInteger       pagesCount;         //总页数
    NSMutableArray  *contentViews;      //内容视图
    NSTimer         *animationTimer;    //动画计时器
}

///滚动视图
@property (nonatomic, strong)   UIScrollView            *scrollView;

///时间间隔
@property (nonatomic, assign)   NSTimeInterval          animationDuration;

///获取页数
@property (nonatomic, copy)     numberOfPagesBlock      numberOfPagesBlock;

///内容视图
@property (nonatomic, copy)     contentViewBlock        contentViewBlock;

///页控制器（白点）
@property (nonatomic, copy)     pageControlBlock        pageControlBlock;

///文本
@property (nonatomic, copy)     textLabelBlock          textLabelBlock;

///点击事件
@property (nonatomic, copy)     tapBlock                tapBlock;

@end

@implementation PFCarouselView

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration delegate:(id<PFCarouselViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        //滚动视图
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];

        //页控制器（白点）
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.center = CGPointMake(self.scrollView.center.x, self.scrollView.bounds.size.height - 40);
        self.pageControl.currentPage = 0;
        [self addSubview:self.pageControl];

        //文本
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.size.height - 30, self.bounds.size.width, 30)];
        self.textLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.300];
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textLabel];

        /*
         *p.s. 因为滚动视图的滚动数是从0开始，所以当前页为0，其实是第一页
         */
        //设置当前页为第一页
        currentPageIndex = 0;
    }

    if (animationDuration > 0.0) {//设置计时器
        animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration) target:self selector:@selector(animationTimerDidFired:) userInfo:nil repeats:YES];

        if (delegate) {//设置代理并获取页数
            self.delegate = delegate;
            [self setupTotalPagesCount:[self.delegate numberOfPagesInCarouselView:self]];
        } else {//暂停计时器
            [animationTimer pauseTimer];
        }
    }
    return self;
}

#pragma mark - Property Methods

//是否显示页控制器（白点）的setter方法
- (void)setPageControlShow:(BOOL)pageControlShow
{
    _pageControlShow = pageControlShow;
    if (!pageControlShow) [self.pageControl removeFromSuperview], self.pageControl = nil;
}

//页控制器（白点）的坐标的setter方法
- (void)setPageControlPoint:(CGPoint)pageControlPoint
{
    _pageControlPoint = pageControlPoint;
    self.pageControl.center = pageControlPoint;
}

//是否显示文本的setter方法
- (void)setTextLabelShow:(BOOL)textLabelShow
{
    _textLabelShow = textLabelShow;
    if (!textLabelShow) [self.textLabel removeFromSuperview], self.textLabel = nil;
}

//文本的尺寸的setter方法
- (void)setTextLabelFrame:(CGRect)textLabelFrame
{
    _textLabelFrame = textLabelFrame;
    self.textLabel.frame = textLabelFrame;
}

#pragma mark - Private Methods

//设置总页数
- (void)setupTotalPagesCount:(NSInteger)count
{
    pagesCount = count;
    if (pagesCount > 0) {
        [self setupContentView];
        //恢复计时器（指定时间间隔后恢复）
        [animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }

    //设置页控制器（白点）的总数
    self.pageControl.numberOfPages = count;
}

//设置内容
- (void)setupContentView
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewDataSource];

    //设置一个计数器
    NSInteger counter = 0;

    //设置内容页（遍历每一页的内容）
    for (UIView *contentView in contentViews) {

        //打开用户交互
        contentView.userInteractionEnabled = YES;

        //添加点击事件
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewDidTap:)];
        [contentView addGestureRecognizer:recognizer];

        //设置内容尺寸和位移
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter++), 0);
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

//设置滚动视图的数据源
- (void)setScrollViewDataSource
{
    //获取上一页的页数
    NSInteger previousPageIndex = [self getNextPageIndex:currentPageIndex - 1];

    //获取下一页的页数
    NSInteger nextPageIndex = [self getNextPageIndex:currentPageIndex + 1];

    //设置内容页数组
    if (contentViews == nil) contentViews = [@[] mutableCopy];
    [contentViews removeAllObjects];

    //添加内容页
    if (!self.delegate && self.contentViewBlock) {//监听块并回调
        [contentViews addObject:self.contentViewBlock(self, previousPageIndex)];
        [contentViews addObject:self.contentViewBlock(self, currentPageIndex)];
        [contentViews addObject:self.contentViewBlock(self, nextPageIndex)];
    } else if ([self.delegate respondsToSelector:@selector(carouselView:contentViewAtIndex:)]) {//监听代理并回调
        [contentViews addObject:[self.delegate carouselView:self contentViewAtIndex:previousPageIndex]];
        [contentViews addObject:[self.delegate carouselView:self contentViewAtIndex:currentPageIndex]];
        [contentViews addObject:[self.delegate carouselView:self contentViewAtIndex:nextPageIndex]];
    }

    //设置页控制器（白点）
    if (!self.delegate && self.pageControlBlock) {//监听块并回调
        self.pageControlBlock(self, self.pageControl, currentPageIndex);
    } else if ([self.delegate respondsToSelector:@selector(carouselView:pageControl:atIndex:)]) {//监听代理并回调
        [self.delegate carouselView:self pageControl:self.pageControl atIndex:currentPageIndex];
    }

    //设置文本
    if (!self.delegate && self.textLabelBlock) {//监听块并回调
        self.textLabelBlock(self, self.textLabel, currentPageIndex);
    } else if ([self.delegate respondsToSelector:@selector(carouselView:textLabel:atIndex:)]) {//监听代理并回调
        [self.delegate carouselView:self textLabel:self.textLabel atIndex:currentPageIndex];
    }
}

//获取下一页的页数
- (NSInteger)getNextPageIndex:(NSInteger)pageIndex
{
    /*
     *p.s. 因为滚动视图的滚动数是从0开始，所以滚动数是总数-1
     */
    //如果传入的页数为-1，返回总页数-1（当前页为最后一页）
    if (pageIndex == -1) return pagesCount - 1;
    //如果传入的页数等于总页数，返回第0页（当前页为第一页）
    else if (pageIndex == pagesCount) return 0;
    //如果传入的页数不是第一页也不是最后一页，则当前页为此页
    else return pageIndex;
}

#pragma mark - Public Methods

//获取页数
- (void)numberOfPagesInCarouselViewUsingBlock:(NSInteger (^)(PFCarouselView *))block
{
    if (block) self.numberOfPagesBlock = block, block = nil;
    if (self.contentViewBlock) [self setupTotalPagesCount:self.numberOfPagesBlock(self)];
}

//获取视图
- (void)contentViewAtIndexUsingBlock:(UIView *(^)(PFCarouselView *, NSInteger))block
{
    if (block) self.contentViewBlock = block, block = nil;
    if (self.numberOfPagesBlock) [self setupTotalPagesCount:self.numberOfPagesBlock(self)];
}

//获取页控制器（白点）
- (void)pageControlAtIndexUsingBlock:(void (^)(PFCarouselView *, UIPageControl *, NSInteger))block
{
    if (block) {
        block(self, self.pageControl, currentPageIndex);
        self.pageControlBlock = block;
        block = nil;
    }
}

//获取文本
- (void)textLabelAtIndexUsingBlock:(void (^)(PFCarouselView *, UILabel *, NSInteger))block
{
    if (block) {
        block(self, self.textLabel, currentPageIndex);
        self.textLabelBlock = block;
        block = nil;
    }
}

//获取点击事件
- (void)didSelectViewAtIndexUsingBlock:(void (^)(PFCarouselView *, NSInteger))block
{
    if (block) self.tapBlock = block, block = nil;
}

#pragma mark - Events Management

//计时器开始
- (void)animationTimerDidFired:(NSTimer *)timer
{
    //设置位移的数值
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);

    //设置位移
    [self.scrollView setContentOffset:newOffset animated:YES];
}

//内容页被点击
- (void)contentViewDidTap:(UITapGestureRecognizer *)recognizer
{
    if (!self.delegate && self.tapBlock) {//监听块并回调
        self.tapBlock(self, currentPageIndex);
    } else if ([self.delegate respondsToSelector:@selector(carouselView:didSelectViewAtIndex:)]) {//监听代理并回调
        [self.delegate carouselView:self didSelectViewAtIndex:currentPageIndex];
    }
}

#pragma mark - UIScrollViewDelegate

//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [animationTimer pauseTimer];
}

//结束拖拽并且开始减速
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //恢复计时器（指定时间间隔后恢复）
    [animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

//停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

//滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //获取位移的x坐标
    int contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        //翻到下一页
        currentPageIndex = [self getNextPageIndex:currentPageIndex + 1];
        [self setupContentView];
    }
    if(contentOffsetX <= 0) {
        //翻到上一页
        currentPageIndex = [self getNextPageIndex:currentPageIndex - 1];
        [self setupContentView];
    }

    //设置页控制器（白点）为当前页
    self.pageControl.currentPage = currentPageIndex;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
