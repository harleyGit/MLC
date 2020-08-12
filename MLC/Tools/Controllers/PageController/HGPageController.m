//
//  HGPageController.m
//  HGSWB
//
//  Created by 黄刚 on 2018/12/30.
//  Copyright © 2018 HuangGang'sMac. All rights reserved.
//

#import "HGPageController.h"

NSString *const HGControllerDidAddToSuperViewNotification = @"HGControllerDidAddToSuperViewNotification";
NSString *const HGControllerDidFullyDisplayedNotification = @"HGControllerDidFullyDisplayedNotification";

static NSInteger const kHGControllerCountUndefined = -1;
static NSInteger const kHGUndefinedIndex = -1;

@interface HGPageController (){
    CGFloat _viewY;
    CGFloat _viewX;
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    CGFloat _superviewHeight;
    CGFloat _targetX;
    NSInteger   _controllerCount;
    NSInteger   _initializedIndex;
    NSInteger   _markedSelectIndex;
    BOOL    _hasInited;
    BOOL    _shouldNotScroll;
    BOOL    _isTabBarHidden;
}

@property(nonatomic, readonly) NSInteger childControllersCount;     //返回controller的数目

@end

@implementation HGPageController
#pragma mark -- Get
- (NSInteger)childControllersCount {
    if (_controllerCount == kHGControllerCountUndefined) {
        if ([self.dataSource respondsToSelector:@selector(numbersOfChildControllersInPageController:)]) {
            _controllerCount = [self.dataSource numbersOfChildControllersInPageController:self];
        }else {
            _controllerCount = self.viewControllerClasses.count;
        }
    }
    return _controllerCount;
}

- (NSMutableDictionary *)displayVC {
    if (!_displayVC) {
        _displayVC = [[NSMutableDictionary alloc] init];
    }
    return _displayVC;
}

- (NSMutableDictionary *)posRecords {
    if (!_posRecords) {
        _posRecords = [[NSMutableDictionary alloc] init];
    }
    return _posRecords;
}

- (NSMutableDictionary *)backgroundCache {
    if (!_backgroundCache) {
        _backgroundCache = [NSMutableDictionary new];
    }
    return _backgroundCache;
}


#pragma mark -- Method

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithViewControllerClasses:(NSArray<Class> *)classes andTheirTitles:(NSArray<NSString *> *)titles {
    self = [super init];
    if (self) {
        NSParameterAssert(classes.count == titles.count);    //断言报错
        _viewControllerClasses = [NSArray arrayWithArray:classes];
        _titles = [NSArray arrayWithArray:titles];
        
        [self setup];
    }
    return self;
}

- (void) setup {
    _titleSizeSelected = 18.0f;
    _titleSizeNormal = 15.0f;
    _titleColorSelected = [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1];
    _titleColorNormal = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    
    _menuBGColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0];
    _menuHeight = 36.0f;
    _menuItemWidth = 65.0f;
    
    /*
     //存储rongliang。
     totalCostLimit;
     //存储上限
     countLimit
     
     //比如：countLimit = 6，totalCostLimit = 20。那么当存储到第7个时会把最前面的1删除掉，以此类推，就像队列一样。 
     */
    _memCache = [[NSCache alloc] init];
    _initializedIndex = kHGUndefinedIndex;
    _markedSelectIndex = kHGUndefinedIndex;
    _controllerCount = kHGControllerCountUndefined;
    _scrollEnable = YES;
    
    self.automaticallyCalculatesItemWidths = NO;
    self.automaticallyAdjustsScrollViewInsets = NO; //禁用掉自动设置的内边距，自行控制controller上index为0的控件以及scrollview控件的位置
    self.preloadPolicy = HGPageControllerPreloadPolicyNever;
    self.cachePolicy = HGPageControllerCachePolicyNoLimit;
    
    self.delegate = self;
    self.dataSource = self;
    
    //从活动状态进入非活动状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!self.childControllersCount) {
        return;
    }
    
    [self calculateSize];
    [self addScrollView];
    [self addViewControllerAtIndex:self.selectIndex];
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    [self addMenuView];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!self.childControllersCount) {
        return;
    }
    
    CGFloat oldSuperviewHeight = _superviewHeight;
    _superviewHeight = self.view.frame.size.height;
    BOOL oldTabBarIsHidden = _isTabBarHidden;
    _isTabBarHidden = [self bottomView].hidden;
    
    BOOL shouldNotLayout = (_hasInited && _superviewHeight == oldSuperviewHeight && _isTabBarHidden == oldTabBarIsHidden);
    if (shouldNotLayout) {
        return;
    }
    //_childViewFrames存储子视图的frame值
    [self calculateSize];
    //设置self.scrollView的属性值
    [self adjustScrollViewFrame];
    [self adjustMenuViewFrame]; //menuView 内的子view的frame配置
    [self adjustDisplayingViewControllersFrame];    //初始化第一个controller的view的frame值
    _hasInited = YES;
    [self.view layoutIfNeeded];
    [self delaySelectIndexIfNeeded];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.childControllersCount) {
        return;
    }
    
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
    [self didEnterController:self.currentViewController atIndex:self.selectIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    self.memoryWaringCount ++;
    self.cachePolicy = HGPageControllerCachePolicyLowMemory;
    //取消正在增长的 cache 操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyAfterMemoryWarning) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyToHigh) object:nil];
    
    [self.memCache removeAllObjects];
    [self.posRecords removeAllObjects];
    self.posRecords = nil;
    
    //如果收到内存警告次数小于 3，一段时间后切换到模式 Balanced
    if (self.memoryWaringCount < 3) {
        [self performSelector:@selector(growCachePolicyAfterMemoryWarning) withObject:nil afterDelay:3.0 inModes:@[NSRunLoopCommonModes]];
    }
}


- (void) postFullyDisplayedNotificationWithCurrentIndex:(int)index {
    if (!self.postNotification) {
        return;
    }
    
    NSDictionary *info = @{
                           @"index":@(index),
                           @"title":[self titleAtIndex:index]
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:HGControllerDidFullyDisplayedNotification object:info];
    
}


- (void) delaySelectIndexIfNeeded {
    if (_markedSelectIndex != kHGUndefinedIndex) {
        self.selectIndex = (int)_markedSelectIndex;
    }
}

//UIViewController 的frame值设置
- (void) adjustDisplayingViewControllersFrame {
    [self.displayVC enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIViewController  *_Nonnull vc, BOOL * _Nonnull stop) {
        NSInteger index = key.integerValue;
        CGRect frame = [self.childViewFrames[index] CGRectValue];
        vc.view.frame = frame;
    }];
}

- (void) adjustMenuViewFrame {
    //根据是否在导航栏上展示调整frame
    CGFloat menuHeight = self.menuHeight;
    __block CGFloat menuX = _viewX;
    __block CGFloat menuY = _viewY;
    __block CGFloat rightWidth = 0;
    
    if (self.showOnNavigationBar && self.navigationController.navigationBar) {
        [self.navigationController.navigationBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isKindOfClass:[HGMenuView class]] && [obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")] && obj.alpha != 0 && obj.hidden == NO) {
                CGFloat maxX = CGRectGetMaxX(obj.frame);
                if (maxX < self->_viewWidth / 2) {
                    CGFloat leftWidth = maxX;
                    menuX = menuX > leftWidth ? menuX : leftWidth;
                }
                CGFloat minX = CGRectGetMinX(obj.frame);
                if (minX > self->_viewWidth / 2) {
                    CGFloat width = (self->_viewWidth - minX);
                    rightWidth = rightWidth > width ? rightWidth : width;
                }
            }
        }];
        
        CGFloat navHeigt = self.navigationController.navigationBar.frame.size.height;
        menuHeight = self.menuHeight > navHeigt ? navHeigt : self.menuHeight;
        menuY = (navHeigt - menuHeight) / 2;
    }
    CGFloat menuWidth = _viewWidth - menuX - rightWidth;
    CGFloat oriWidth = self.menuView.frame.size.width;
    self.menuView.frame = CGRectMake(menuX, menuY, menuWidth, menuHeight);
    [self.menuView resetFrames];    //计算menu的item的frame的值
    if (oriWidth != menuWidth) {
        [self.menuView refreshContentOffset];
    }
}

- (void) adjustScrollViewFrame {
    _shouldNotScroll = YES;
    CGRect scrollFrame = CGRectMake(_viewX, _viewY + self.menuHeight + self.menuViewBottomSpace, _viewWidth, _viewHeight);
    CGFloat oldContentOffsetX = self.scrollView.contentOffset.x;
    CGFloat contentWidth = self.scrollView.contentSize.width;
    scrollFrame.origin.y -= self.showOnNavigationBar && self.navigationController.navigationBar ? self.menuHeight : 0;
    self.scrollView.frame = scrollFrame;
    self.scrollView.contentSize = CGSizeMake(self.childControllersCount * _viewWidth, 0);
    CGFloat xContentOffset = contentWidth == 0 ? self.selectIndex * _viewWidth : oldContentOffsetX / contentWidth * self.childControllersCount * _viewWidth;
    [self.scrollView setContentOffset:CGPointMake(xContentOffset, 0)];
    _shouldNotScroll = NO;
}

- (void) calculateSize {
    CGFloat navigationHeight = 64;// CGRectGetMaxY(self.navigationController.navigationBar.frame);
    UIView *tabBar = [self bottomView];
    CGFloat height = (tabBar && !tabBar.hidden) ? CGRectGetHeight(tabBar.frame) : 0;
    CGFloat tabBarHeight = (self.hidesBottomBarWhenPushed == YES) ? 0 : height;
    //计算相对 window 的绝对 frame (self.view.window 可能为 nil)
    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
    //将rect由rect所在视图self.view转换到目标视图mainWindow中，返回在目标视图mainWindow中的rect
    CGRect absoluteRect = [self.view convertRect:self.view.bounds toView:mainWindow];
    navigationHeight -= absoluteRect.origin.y;
    tabBarHeight -= mainWindow.frame.size.height - CGRectGetMaxY(absoluteRect);
    
    _viewX = self.viewFrame.origin.x;
    _viewY = self.viewFrame.origin.y;
    if (CGRectEqualToRect(self.viewFrame, CGRectZero)) {
        _viewWidth = self.view.frame.size.width;
        //获得内容视图高度
        _viewHeight = self.view.frame.size.height - self.menuHeight - self.menuViewBottomSpace - navigationHeight -tabBarHeight;
        _viewY += navigationHeight;
    }else {
        _viewWidth = self.viewFrame.size.width;
        _viewHeight = self.viewFrame.size.height - self.menuHeight - self.menuViewBottomSpace;
    }
    
    if (self.showOnNavigationBar && self.navigationController.navigationBar) {
        _viewHeight += self.menuHeight;
    }   //重新计算各个控制器视图的宽高
    _childViewFrames = [NSMutableArray array];
    for (int i = 0; i < self.childControllersCount; i ++) {
        CGRect frame = CGRectMake(i * _viewWidth, 0, _viewWidth, _viewHeight);
        [_childViewFrames addObject:[NSValue valueWithCGRect:frame]];   //NSValue可以包装任意一个对象，包括系统自定义的数据结构，结构体等等
    }
}

- (UIView *)bottomView {
    return self.tabBarController.tabBar ? self.tabBarController.tabBar : self.navigationController.toolbar;
}

- (void) configurationScrollView {
    
    [self clearDatas];
    if (!self.childControllersCount) {
        return;
    }
    
    [self configurationMenuView];
    [self configurationContentScrollView];
    [self.memCache removeAllObjects];
    [self viewDidLayoutSubviews];
}

//清除数据
- (void) clearDatas {
    _controllerCount = kHGControllerCountUndefined;
    _hasInited = NO;
    
    NSUInteger maxIndex = (self.childControllersCount -1 > 0) ? (self.childControllersCount -1) : 0;
    _selectIndex = self.selectIndex < self.childControllersCount ? self.selectIndex : (int)maxIndex;    //设置选中几号Item
    if (self.progressWidth > 0) {
        self.progressWidth = self.progressWidth;    //设置进度条
    }
    
    NSArray *displayingViewControllers = self.displayVC.allValues;  //displayVC是展示在屏幕上的控制器，方便在滚动的时候读取
    for (UIViewController *vc in displayingViewControllers) {
        [vc.view removeFromSuperview];
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
    self.memoryWaringCount = 0; //收到内存警告的次数
    //取消已设置的延迟执行方法：https://blog.csdn.net/wmqi10/article/details/47754241
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyAfterMemoryWarning) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyToHigh) object:nil];
    self.currentViewController = nil;
    [self.posRecords removeAllObjects]; //posRecords用于记录销毁的viewController的位置
    [self.displayVC removeAllObjects];  //displayVC当前展示在屏幕上的控制器，方便在滚动的时候读取 (避免不必要计算)
}

- (void) configurationMenuView {
    NSLog(@"配置MenuView");
    if (!self.menuView) {
        [self addMenuView];
    }else {
        [self.menuView reload];
        if (self.menuView.userInteractionEnabled == NO) {
            self.menuView.userInteractionEnabled = YES;
        }
        
        if (self.selectIndex != 0) {
            [self.menuView selectItemAtIndex:self.selectIndex];
        }
        [self.view bringSubviewToFront:self.menuView];
    }
}

- (void) configurationContentScrollView {
    NSLog(@"配置ContentView");
    
    if (self.scrollView) {
        [self.scrollView removeFromSuperview];
    }
    
    [self addScrollView];   //初始化ScrollView
    [self addViewControllerAtIndex:self.selectIndex];   //electIndex 设置选中几号
    self.currentViewController = self.displayVC[@(self.selectIndex)];
}

- (void) addScrollView {
    HGScrollView *scrollView = [HGScrollView new];
    scrollView.scrollsToTop = NO;   //滚动到顶部是否禁止
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = self.bounces;
    scrollView.otherGestuteRecognizerSimultaneously = self.otherGestureRecognizerSimultaneously;
    scrollView.scrollEnabled = self.scrollEnable;
    
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    if (!self.navigationController) {
        return;
    }
    
    //解决：UINavigationController的侧滑手势与UIScrollView滚动手势冲突
    for (UIGestureRecognizer *gestureRecognizer in scrollView.gestureRecognizers) {
        [gestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    }
}

- (void) addMenuView {
    CGFloat menuY = _viewY;
    if (self.showOnNavigationBar && self.navigationController.navigationBar) {
        CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
        CGFloat menuHeight = self.menuHeight > navHeight ? navHeight : self.menuHeight;
        menuY = (navHeight - menuHeight) / 2;
    }
    
    CGRect frame = CGRectMake(_viewX, menuY, _viewWidth, self.menuHeight);
    HGMenuView *menuView = [[HGMenuView alloc] initWithFrame:frame];
    menuView.backgroundColor = self.menuBGColor;
    menuView.delegate = self;
    menuView.dataSource = self;
    menuView.style = self.menuViewStyle;//选中效果
    menuView.layoutMode = self.menuViewLayoutMode; //Item的布局样式
    menuView.progressHeight = self.progressHeight;
    menuView.contentMargin = self.menuViewContentMargin;
    menuView.progressViewBottomSpace = self.progressViewBottomSpace;
    menuView.progressWidths = self.progressViewWidths;
    menuView.progressViewIsNaughty = self.progressViewIsNaughty;
    menuView.progressViewCornerRadius = self.progressViewCornerRadius;
    if (self.titleFontName) {
        menuView.fontName = self.titleFontName;
    }
    if (self.progressColor) {
        menuView.lineColor = self.progressColor;
    }
    if (self.showOnNavigationBar && self.navigationController.navigationBar) {
        self.navigationItem.titleView = menuView;
    }else {
        [self.view addSubview:menuView];
    }
    
    self.menuView = menuView;
    
}

#pragma mark -- HGMenuViewDelegate
- (CGFloat)menuView:(HGMenuView *)menu itemMarginAtIndex:(NSInteger)index {
    if (self.itemsMargins.count == self.childControllersCount +1) {
        return [self.itemsMargins[index] floatValue];
    }
    return self.itemMargin;
}

//计算Menu计算item的title宽度
- (CGFloat)menuView:(HGMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    if (self.automaticallyCalculatesItemWidths) {//通过Menu的计算item的title的宽度
        return [self calculateItemWithAtIndex:index];
    }
    
    if (self.itemsWidhts.count ==  self.childControllersCount) {
        return  [self.itemsWidhts[index] floatValue];
    }
    return self.menuItemWidth;
}

//选中与非选中状态下MenuItem的title的size状态变化
- (CGFloat) menuView:(HGMenuView *)menu titleSizeForState:(HGMenuItemState)state atIndex:(NSInteger)index {
    switch (state) {
        case HGMenuItemStateSelected:
            return self.titleSizeSelected;
            break;
            case HGMenuItemStateNormal:
            return self.titleSizeNormal;
            
        default:
            break;
    }
}

//选中与非选中状态下MenuItem的title的color状态变化
- (UIColor *)menuView:(HGMenuView *)menu titleColorForState:(HGMenuItemState)state atIndex:(NSInteger)index {
    switch (state) {
        case HGMenuItemStateSelected:
            return self.titleColorSelected;
            break;
            
        case HGMenuItemStateNormal:
            return self.titleColorNormal;
            break;
            
        default:
            break;
    }
}

//点击Menu上的Item触发的方法
- (void)menuView:(HGMenuView *)menu didSelectedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex {
    if (!_hasInited) {
        return;
    }
    _selectIndex = (int)index;
    _startDragging = NO;
    CGPoint targetP = CGPointMake(_viewWidth * index, 0);
    [self.scrollView setContentOffset:targetP animated:self.pageAnimatable];    //调用代理方法 scrollViewDidScroll：添加和删除控制器
    
    if (self.pageAnimatable) {
        return;
    }
    
    //用于不触发 -scrollViewDidScroll: 手动处理控制器
    UIViewController *currentViewController = self.displayVC[@(currentIndex)];
    if (currentViewController) {
        [self removeViewController:currentViewController atIndex:currentIndex];
    }
    
    [self layoutChildViewControllers];
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    [self postFullyDisplayedNotificationWithCurrentIndex:(int)index];
    [self didEnterController:self.currentViewController atIndex:index];
}

#pragma mark -- HGMenuViewDataSource
- (NSInteger)numberOfTitlesInMenuView:(HGMenuView *)menu {
    return self.childControllersCount;
}

- (NSString *)menuView:(HGMenuView *)menu titleAtIndex:(NSInteger)index {
    return [self titleAtIndex:index];
}

#pragma mark -- UIScrollViewDelegate
//触发 contentOffset 变化的时候都会被调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:HGScrollView.class]) {
        return;
    }
    
    if (_shouldNotScroll || !_hasInited) {
        return;
    }
    //设置self.displayVC的字典值
    [self layoutChildViewControllers];
    
    if (_startDragging) {
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        if (contentOffsetX < 0) {
            contentOffsetX = 0;
        }
        
        if (contentOffsetX > scrollView.contentSize.width - _viewWidth) {
            contentOffsetX = scrollView.contentSize.width - _viewWidth;
        }
        
        CGFloat rate = contentOffsetX / _viewWidth;
        [self.menuView slideMenuAtProgress:rate];
    }
    
    if (scrollView.contentOffset.y == 0) {
        return;
    }
    CGPoint contentOffset = scrollView.contentOffset;
    contentOffset.y = 0.0;
    scrollView.contentOffset = contentOffset;
}

//用户开始拖动 scroll view 的时候被调用，可能需要一些时间和距离移动之后才会触发
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:HGScrollView.class]) {
        return;
    }
    
    _startDragging = YES;
    self.menuView.userInteractionEnabled = NO;
}


//减速动画结束时被调用，这里有一种特殊情况：当一次减速动画尚未结束的时候再次 drag scroll view，didEndDecelerating 不会被调用，并且这时 scroll view 的 dragging 和 decelerating 属性都是 YES。
// 新的 dragging 如果有加速度，那么 willBeginDecelerating 会再一次被调用，然后才是 didEndDecelerating；
// 如果没有加速度，虽然 willBeginDecelerating 不会被调用，但前一次留下的 didEndDecelerating 会被调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:HGScrollView.class]) {
        return;
    }
    
    self.menuView.userInteractionEnabled = YES;
    _selectIndex = (int)(scrollView.contentOffset.x / _viewWidth);
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
    [self didEnterController:self.currentViewController atIndex:self.selectIndex];
    [self.menuView deselectedItemsIfNeeded];
}

//滚动完毕就会调用（如果不是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (![scrollView isKindOfClass:HGScrollView.class]) {
        return;
    }
    
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
    [self didEnterController:self.currentViewController atIndex:self.selectIndex];
    [self.menuView deselectedItemsIfNeeded];
}


//在用户结束拖动后被调用，decelerate 为 YES 时，结束拖动后会有减速过程。注:在 didEndDragging 之后，如果有减速过程。scroll view 的 dragging 并不会立即置为 NO，而是要等到减速结束之后。
// 所以这个 dragging 属性的实际语义更接近 scrolling
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([scrollView isKindOfClass:HGScrollView.class]) {
        return;
    }
    
    if (!decelerate) {
        self.menuView.userInteractionEnabled = YES;
        CGFloat rate = _targetX / _viewWidth;
        [self.menuView slideMenuAtProgress:rate];
        [self.menuView deselectedItemsIfNeeded];
    }
}


// 在 didEndDragging 前被调用，当 willEndDragging 方法中 velocity 为 CGPointZero（结束拖动时两个方向都没有速度）时，didEndDragging 中的 decelerate 为 NO，即没有减速过程，willBeginDecelerating 和 didEndDecelerating 也就不会被调用。反之，
// 当 velocity 不为 CGPointZero 时，scroll view 会以 velocity 为初速度，减速直到 targetContentOffset。
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (![scrollView isKindOfClass:HGScrollView.class]) {
        return;
    }
    _targetX = targetContentOffset->x;
}

#pragma mark -- Notification
- (void)willResignActive:(NSNotification *)notification {
    for (int i = 0; i < self.childControllersCount; i ++) {
        id obj = [self.memCache objectForKey:@(i)];
        if (obj) {
            [self.backgroundCache setObject:obj forKey:@(i)];
        }
    }
}

- (void) willEnterForeground:(NSNotification *)notification {
    for (NSNumber *key in self.backgroundCache.allKeys) {
        if (![self.memCache objectForKey:key]) {
            [self.memCache setObject:self.backgroundCache[key] forKey:key];
        }
    }
    [self.backgroundCache removeAllObjects];
}


//完全进入控制器 (即停止滑动后调用)
- (void)didEnterController:(UIViewController *)vc atIndex:(NSInteger)index {
    if (!self.childControllersCount) {
        return;
    }
    
    NSDictionary *info = [self infoWithIndex:index];
    if ([self.delegate respondsToSelector:@selector(pageController:didEnterViewController:withInfo:)]) {
        [self.delegate pageController:self didEnterViewController:vc withInfo:info];
    }
    
    //当控制器创建时，调用延迟加载的代理方法
    if (_initializedIndex == index && [self.delegate respondsToSelector:@selector(pageController:lazyLoadViewController:withInfo:)]) {
        [self.delegate pageController:self lazyLoadViewController:vc withInfo:info];
        _initializedIndex = kHGUndefinedIndex;
    }
    
    //根据 preloadPolicy 预加载控制器
    if (self.preloadPolicy == HGPageControllerPreloadPolicyNever) {
        return;
    }
    int length = (int)self.preloadPolicy;
    int start = 0;
    int end = (int)self.childControllersCount -1;
    if (index > length) {
        start = (int) index - length;
    }
    if (self.childControllersCount -1 > length + index) {
        end = (int)index + length;
    }
    for (int i = start; i <= end; i ++) {
        //
        if (![self.memCache objectForKey:@(i)] && !self.displayVC[@(i)]) {
            [self addViewControllerAtIndex:i];
            [self postAddToSuperViewNotificationWithIndex:i];
        }
    }
    _selectIndex = (int)index;
}


//移除或者添加视图控制器
- (void)layoutChildViewControllers {
    int currentPage = (int) (self.scrollView.contentOffset.x / _viewWidth);
    int lengtn = (int)self.preloadPolicy;
    int left = currentPage - lengtn - 1;
    int right = currentPage + lengtn + 1;
    
    for (int i = 0; i < self.childControllersCount; i ++) {
        UIViewController *vc = [self.displayVC objectForKey:@(i)];
        CGRect frame =  [self.childViewFrames[i] CGRectValue];
        if (!vc) {
            if ([self isInScreen:frame]) {
                [self initializedControllerWithIndexIfNeeded:i];    //创建或从缓存中获取控制器并添加到视图上
            }
        }else if (i <= left || i >= right) {
            if (![self isInScreen:frame]) {
                [self removeViewController:vc atIndex:i];   //移除视图控制器
            }
        }
    }
}

- (void) initializedControllerWithIndexIfNeeded:(NSInteger)index {
    //先从 cache 中取
    UIViewController *vc = [self.memCache objectForKey:@(index)];
    if (vc) {
        //cache 中存在，添加到 scrollView 上，并放入display
        [self addCachedViewController:vc atIndex:index];
    }else {
        //cache 中也不存在，创建并添加到display
        [self addViewControllerAtIndex:(int)index];
    }
    [self postAddToSuperViewNotificationWithIndex:(int)index];
}

//当子控制器init完成时发送通知
- (void) postAddToSuperViewNotificationWithIndex:(int)index {
    if (!self.postNotification) {
        return;
    }
    
    NSDictionary *info = @{@"index":@(index), @"title":[self titleAtIndex:index]};
    [[NSNotificationCenter defaultCenter] postNotificationName:HGControllerDidAddToSuperViewNotification object:info];
}


- (void)addViewControllerAtIndex:(int)index {
    _initializedIndex = index;
    //获得展示的UIViewController
    UIViewController *viewController = [self initializeViewControllerAtIndex:index];
    if (self.values.count == self.childControllersCount && self.keys.count == self.childControllersCount) {
        [viewController setValue:self.values[index] forKey:self.keys[index]];
    }
    
    //完成父子视图关系建立
    [self addChildViewController:viewController];   //https://www.jianshu.com/p/2148f9cfa010
    CGRect frame = self.childViewFrames.count ? [self.childViewFrames[index] CGRectValue] : self.view.frame;
    viewController.view.frame = frame;
    [viewController didMoveToParentViewController:self];
    [self.scrollView addSubview:viewController.view];
    [self willEnterController:viewController atIndex:index];
    [self.displayVC setObject:viewController forKey:@(index)];
    
    [self backToPositionIfNeeded:viewController atIndex:index];
}

- (void) backToPositionIfNeeded:(UIViewController *)controller atIndex:(NSInteger)index {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (!self.rememberLocation) {
        return;
    }
#pragma clang diagnostic pop
    if ([self.memCache objectForKey:@(index)]) {
        return;
    }
    UIScrollView *scrollView = [self isKindOfScrollViewController:controller];
    if (scrollView) {
        NSValue *pointValue = self.posRecords[@(index)];
        if (pointValue) {
            CGPoint pos = [pointValue CGPointValue];
            [scrollView setContentOffset:pos];
        }
    }
}


- (UIViewController * _Nonnull)initializeViewControllerAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(pageController:viewControllerAtIndex:)]) {
        return [self.dataSource pageController:self viewControllerAtIndex:index];
    }
    
    return [[self.viewControllerClasses[index] alloc] init];
}


//添加视图控制器
- (void) addCachedViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    [self addChildViewController:viewController];
    viewController.view.frame = [self.childViewFrames[index] CGRectValue];
    [viewController didMoveToParentViewController:self];
    [self.scrollView addSubview:viewController.view];
    [self willEnterController:viewController atIndex:index];
    [self.displayVC setObject:viewController forKey:@(index)];
}

- (void)willEnterController:(UIViewController *)vc atIndex:(NSInteger)index {
    _selectIndex = (int)index;
    if (self.childControllersCount && [self.delegate respondsToSelector:@selector(pageController:willEnterViewController:withInfo:)]) {
        NSDictionary *info = [self infoWithIndex:index];
        [self.delegate pageController:self willEnterViewController:vc withInfo:info];
    }
}

//判断view是否存在
- (BOOL) isInScreen:(CGRect)frame {
    CGFloat x = frame.origin.x;
    CGFloat ScreenWidth = self.scrollView.frame.size.width;
    
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    //CGRectGetMaxX 返回View右边缘的坐标
    if (CGRectGetMaxX(frame) > contentOffsetX && x - contentOffsetX < ScreenWidth) {
        return YES;
    }else {
        return NO;
    }
}

- (void) removeViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    [self rememberPositionIfNeeded:viewController atIndex:index];   //存储
    //视图控制器移除
    [viewController.view removeFromSuperview];
    [viewController willMoveToParentViewController:nil];
    [viewController removeFromParentViewController];
    [self.displayVC removeObjectForKey:@(index)];
    
    //放入缓存
    if (self.cachePolicy == HGPageControllerCachePolicyDisabled) {
        return;
    }
    
    if (![self.memCache objectForKey:@(index)]) {
        [self willCahedController:viewController atIndex:index];
        [self.memCache setObject:viewController forKey:@(index)];//缓存加载过的控制器
    }
}

//Cache 缓存加载过的ViewController
- (void) willCahedController:(UIViewController *)vc atIndex:(NSInteger) index {
    if (self.childControllersCount && [self.delegate respondsToSelector:@selector(pageController:willCachedViewController:withInfo:)]) {
        NSDictionary *info = [self infoWithIndex:index];
        [self.delegate pageController:self willCachedViewController:vc withInfo:info];
    }
}

- (NSDictionary *)infoWithIndex:(NSInteger)index {//Menu对应的索引和title键值对
    NSString *title = [self titleAtIndex:index];
    return @{@"title": title ? title : @"", @"index": @(index)};
}

- (void) rememberPositionIfNeeded:(UIViewController *)controller atIndex:(NSInteger)index {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (!self.rememberLocation) {
        return;
    }
#pragma clang diagnostic pop
    UIScrollView *scrollView = [self isKindOfScrollViewController:controller];
    if (scrollView) {
        CGPoint pos = scrollView.contentOffset;
        self.posRecords[@(index)] = [NSValue valueWithCGPoint:pos];//存储销毁的scrollviewPoint
    }
}

- (UIScrollView *)isKindOfScrollViewController:(UIViewController *)controller {
    UIScrollView *scrollView = nil;
    if ([controller.view isKindOfClass:[UIScrollView class]]) {
        //Controller的view是scrollView的子类(UITableViewController/UIViewController替换view为scrollView)
        scrollView = (UIScrollView *)controller.view;
    }else if(controller.view.subviews.count >= 1){
        //Controller的view的subViews[0]存在且是scrollView的子类，并且frame等与view得frame(UICollectionViewController/UIViewController添加UIScrollView)
        UIView *view = controller.view.subviews[0];
        if ([view isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)view;
        }
    }
    return scrollView;
}


- (CGFloat) calculateItemWithAtIndex:(NSInteger)index {
    NSString *title = [self titleAtIndex:index];
    UIFont *titleFont = self.titleFontName ? [UIFont fontWithName:self.titleFontName size:self.titleSizeSelected] : [UIFont systemFontOfSize:self.titleSizeSelected];
    NSDictionary *attrs = @{NSFontAttributeName: titleFont};
    CGFloat itemWidth = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attrs context:nil].size.width;
    
    return ceil(itemWidth);
}


//返回索引的title
- (NSString * _Nonnull) titleAtIndex:(NSInteger)index {
    NSString *title = nil;
    if ([self.dataSource respondsToSelector:@selector(pageController:titleAtIndex:)]) {
        title = [self.dataSource pageController:self titleAtIndex:index];
    }else {
        title = self.titles[index];
    }
    
    return (title ? title: @"");
}

- (void)growCachePolicyAfterMemoryWarning {
    self.cachePolicy = HGPageControllerCachePolicyBalanced;
    [self performSelector:@selector(growCachePolicyToHigh) withObject:nil afterDelay:2.0 inModes:@[NSRunLoopCommonModes]];  //NSRunLoopCommonModes使用该模式可以防止UI的干扰：https://www.jianshu.com/p/360156006195
}

- (void)growCachePolicyToHigh {
    self.cachePolicy = HGPageControllerCachePolicyHigh;
}

@end
