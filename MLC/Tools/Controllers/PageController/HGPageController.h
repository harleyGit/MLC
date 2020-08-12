//
//  HGPageController.h
//  HGSWB
//
//  Created by 黄刚 on 2018/12/30.
//  Copyright © 2018 HuangGang'sMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HGPageController;
@class HGScrollView;

typedef NS_ENUM(NSInteger, HGPageControllerCachePolicy) {
    HGPageControllerCachePolicyDisabled     = -1,   // Disable Cache
    HGPageControllerCachePolicyNoLimit      = 0,    // No limit
    HGPageControllerCachePolicyLowMemory    = 1,    // Low Memory but may block when scroll
    HGPageControllerCachePolicyBalanced     = 3,    // Balanced ↑ and ↓//缓存策略平衡
    HGPageControllerCachePolicyHigh         = 5     //High
};

typedef NS_ENUM(NSUInteger, HGPageControllerPreloadPolicy) {
    HGPageControllerPreloadPolicyNever      =   0,     //Never pre-load controller
    HGPageControllerPreloadPolicyNeighbour  =   1,     //Pre-load the controller next to the current.
    HGPageControllerPreloadPolicyNear       =   2,      //Pre-load 2 controllers near the current.
};

NS_ASSUME_NONNULL_BEGIN
extern NSString *const HGControllerDidAddToSuperViewNotification;
extern NSString *const HGControllerDidFullyDisplayedNotification;

@protocol HGPageControllerDelegate <NSObject>

-(void)pageController:(HGPageController *)pageController willCachedViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info;

- (void)pageController:(HGPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info;

- (void)pageController:(HGPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info;


/**
 If the child controller is heavy, put some work in this method. This method will only be called when the controller is initialized and stop scrolling. (That means if the controller is cached and hasn't released will never call this method.)

 @param pageController The parent controller
 @param viewController The viewController first show up when scroll stop.
 @param info A dictionary that includes some infos, such as: `index` / `title`
 */
- (void)pageController:(HGPageController *)pageController lazyLoadViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info;

@end

@protocol HGPageControllerDataSource <NSObject>

@optional

/**
 在pageControlelr中childController的个数

 @param pageControlelr 标签controller的容器
 @return childController的个数
 */
- (NSInteger)numbersOfChildControllersInPageController:(HGPageController *)pageControlelr;
//返回索引所在的item的title
- (NSString *)pageController:(HGPageController *)pageController titleAtIndex:(NSInteger)index;

- (__kindof UIViewController *)pageController:(HGPageController *)pageController viewControllerAtIndex:(NSInteger)index;

@end


@interface HGPageController : UIViewController<HGMenuViewDataSource, HGMenuViewDelegate, UIScrollViewDelegate, HGPageControllerDelegate, HGPageControllerDataSource>

@property(nonatomic, weak)  id<HGPageControllerDelegate> delegate;
@property(nonatomic, weak)  id<HGPageControllerDataSource> dataSource;

@property(nonatomic, nullable, weak) HGMenuView *menuView;


/**
 是否作为 NavigationBar 的 titleView 展示，默认 NO
 */
@property(nonatomic, assign) BOOL showOnNavigationBar;

/**
 导航栏高度
 */
@property(nonatomic, assign) CGFloat menuHeight;

/**
 导航栏背景色
 */
@property(nonatomic, strong) UIColor *menuBGColor;

/**
 Menu view 的样式，默认为无下划线
 */
@property(nonatomic, assign) HGMenuViewStyle menuViewStyle;

/**
 Menu View 的布局样式
 */
@property(nonatomic, assign) HGMenuViewLayoutMode menuViewLayoutMode;

/**
 下划线进度条高度
 */
@property(nonatomic, assign) CGFloat progressHeight;

/**
 MenuView 内部视图与左右的间距
 */
@property(nonatomic, assign) CGFloat menuViewContentMargin;

/** progressView 到 menuView 底部的距离 */
@property(nonatomic, assign) CGFloat progressViewBottomSpace;

/**
 *  定制进度条在各个 item 下的宽度
 */
@property(nonatomic, nullable, strong) NSArray *progressViewWidths;

/**
 顶部菜单栏各个 item 的间隙，因为包括头尾两端，所以确保它的数量等于控制器数量 + 1, 默认间隙为 0
 */
@property(nonatomic, nullable, copy) NSArray<NSNumber *> *itemsMargins;

/**
 各个控制器的 class, 例如:[UITableViewController class]
 */
@property(nonatomic, nullable, copy) NSArray<Class> *viewControllerClasses;

/**
 如果各个间隙都想同，设置该属性，默认为 0
 */
@property(nonatomic, assign) CGFloat itemMargin;

/**
 是否自动通过字符串计算 MenuItem 的宽度，默认为 NO
 */
@property(nonatomic, assign) BOOL automaticallyCalculatesItemWidths;

/**
 各个控制器的标题
 */
@property(nonatomic, nullable, copy) NSArray<NSString *> *titles;

/**
 标题的字体名字
 */
@property(nonatomic, nullable, copy) NSString *titleFontName;

/**
 选中时的标题尺寸
 */
@property(nonatomic, assign) CGFloat titleSizeSelected;

/**
 非选中时的标题尺寸
 */
@property(nonatomic, assign) CGFloat titleSizeNormal;

/**
 标题选中时的颜色, 颜色是可动画的.
 */
@property(nonatomic, strong) UIColor *titleColorSelected;

/**
 标题未选中时的颜色, 颜色是可动画的
 */
@property(nonatomic, strong) UIColor *titleColorNormal;

/**
 各个 MenuItem 的宽度，可不等，数组内为 NSNumber.
 */
@property(nonatomic, nullable, copy) NSArray<NSNumber *> *itemsWidhts;

/**
 每个 MenuItem 的宽度
 */
@property(nonatomic, assign) CGFloat menuItemWidth;

/**
 调皮效果，用于实现腾讯视频新效果，请设置一个较小的 progressWidth
 */
@property(nonatomic, assign) BOOL progressViewIsNaughty;
//progressView的cornerRadius
@property(nonatomic, assign) CGFloat progressViewCornerRadius;

/**
 进度条的颜色，默认和选中颜色一致(如果 style 为 Default，则该属性无用)
 */
@property(nonatomic, nullable, strong) UIColor *progressColor;

/**
 设置选中几号 item
 */
@property(nonatomic, assign) int selectIndex;

/**
 用代码设置 contentView 的 contentOffset 之前，请设置 startDragging = YES
 */
@property(nonatomic, assign) BOOL startDragging;

/**
 内部容器
 */
@property(nonatomic, nullable, weak) HGScrollView *scrollView;

/**
 点击的 MenuItem 是否触发滚动动画
 */
@property(nonatomic, assign) BOOL pageAnimatable;


/**
 当前展示在屏幕上的控制器，方便在滚动的时候读取 (避免不必要计算
 */
@property(nonatomic, strong) NSMutableDictionary *displayVC;
@property(nonatomic, assign) BOOL rememberLocation __deprecated_msg("Because of the cache policy, this property can abondon now.");

/**
 用于记录销毁的viewController的位置 (如果它是某一种scrollView的Controller的话)
 */
@property(nonatomic, strong) NSMutableDictionary *posRecords;

@property(nonatomic, assign) HGPageControllerCachePolicy cachePolicy;
//用于缓存加载过的控制器
@property(nonatomic, strong) NSCache *memCache;
@property(nonatomic, assign) HGPageControllerPreloadPolicy preloadPolicy;
@property(nonatomic, strong) NSMutableArray *childViewFrames;

/**
 values keys 属性可以用于初始化控制器的时候为控制器传值(利用 KVC 来设置)
 使用时请确保 key 与控制器的属性名字一致！！(例如：控制器有需要设置的属性 type，那么 keys 所放的就是字符串 @"type")
 */
@property(nonatomic, nullable, strong) NSMutableArray<id> *values;
@property(nonatomic, nullable, strong) NSMutableArray<NSString *> *keys;

/**
 是否发送在创建控制器或者视图完全展现在用户眼前时通知观察者，默认为不开启，如需利用通知请开启
 */
@property(nonatomic, assign) BOOL postNotification;
@property(nonatomic, strong, readwrite) UIViewController *currentViewController;
//定制进度条，若每个进度条长度相同，可设置该属性
@property(nonatomic, assign) CGFloat progressWidth;
@property(nonatomic, assign) int memoryWaringCount;

/**
 是否ContentView回弹
 */
@property(nonatomic, assign) BOOL bounces;

/**
 左滑时同时启用其他手势，比如系统左滑、sidemenu左滑。默认 NO
 (会引起一个小问题，第一个和最后一个控制器会变得可以斜滑, 还未解决)
 */
@property(nonatomic, assign) BOOL otherGestureRecognizerSimultaneously;
//scrollView是否能滚动
@property(nonatomic, assign) BOOL scrollEnable;
@property(nonatomic, strong) NSMutableDictionary *backgroundCache;

/**
 顶部 menuView 和 scrollView 之间的间隙
 */
@property(nonatomic, assign) CGFloat menuViewBottomSpace;

/**
 HGPageController View' frame
 */
@property(nonatomic, assign) CGRect viewFrame;




/**
 使用该方法创建控制器. 或者实现数据源方法

 @param classes 子控制器的 class，确保数量与 titles 的数量相等
 @param titles 各个子控制器的标题，用 NSString 描述
 @return instancetype
 */
- (instancetype) initWithViewControllerClasses:(NSArray<Class> *)classes andTheirTitles:(NSArray<NSString *> *)titles;
- (void) configurationScrollView;

@end

NS_ASSUME_NONNULL_END
