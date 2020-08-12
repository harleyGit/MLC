//
//  HGMenuView.h
//  HGSWB
//
//  Created by 黄刚 on 2018/12/30.
//  Copyright © 2018 HuangGang'sMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGMenuItem.h"
@class HGMenuView;
//@class HGMenuItem;
@class HGProgressView;

typedef NS_ENUM(NSInteger, HGMenuViewStyle) {
    HGMenuViewStyleDefault,     //默认
    HGMenuViewStyleLine,        //带下划线(若要选中字体大小不变，设置选中和非选中大小一样即可)
    HGMenuViewStyleTriangle,    //三角形(progressHeight 为三角形的高, progressWidths 为底边长)
    HGMenuViewStyleFlood,       //涌入效果(填充)
    HGMenuViewStyleFloodHollow, //涌入效果(空心的)
    HGMenuViewStyleSegmented,   //涌入带边框，即网易新闻选项卡
};

typedef NS_ENUM(NSUInteger, HGMenuViewLayoutMode) {
    HGMenuViewLayoutModeScatter,        // 默认的布局模式, item 会均匀分布在屏幕上，呈分散状
    HGMenuViewLayoutModeLeft,           // Item 紧靠屏幕左侧
    HGMenuViewLayoutModeRight,          // Item 紧靠屏幕右侧
    HGMenuViewLayoutModeCenter,         // Item 紧挨且居中分布
};

@protocol HGMenuViewDelegate <NSObject>

@optional
- (void)menuView:(HGMenuView *)menu didSelectedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex;
- (CGFloat)menuView:(HGMenuView *)menu itemMarginAtIndex:(NSInteger)index;

//返回menu索引为index的item的宽度值
- (CGFloat)menuView:(HGMenuView *)menu  widthForItemAtIndex:(NSInteger)index;
- (void)menuView:(HGMenuView *)menu didLayoutItemFrame:(HGMenuItem *)menuItem atIndex:(NSInteger)index;
- (CGFloat)menuView:(HGMenuView *)menu titleSizeForState:(HGMenuItemState)state atIndex:(NSInteger)index;
- (UIColor *)menuView:(HGMenuView *)menu titleColorForState:(HGMenuItemState)state atIndex:(NSInteger)index;
@end

@protocol HGMenuViewDataSource <NSObject>

@required
- (NSInteger)numberOfTitlesInMenuView:(HGMenuView *) menu;
- (NSString *)menuView:(HGMenuView *)menu titleAtIndex:(NSInteger)index;

/**
 角标 (例如消息提醒的小红点) 的数据源方法，在 WMPageController 中实现这个方法来为 menuView 提供一个 badgeView
 需要在返回的时候同时设置角标的 frame 属性，该 frame 为相对于 menuItem 的位置

 @param menu MenuView
 @param index 角标的序号
 @return 返回一个设置好 frame 的角标视图
 */
- (UIView *)menuView:(HGMenuView *)menu badgeViewAtIndex:(NSInteger)index;


/**
 用于定制 WMMenuItem，可以对传出的 initialMenuItem 进行修改定制，也可以返回自己创建的子类，需要注意的是，此时的 item 的 frame 是不确定的，所以请勿根据此时的 frame 做计算！
 如需根据 frame 修改，请使用代理

 @param menu 当前的 menuView，frame 也是不确定的
 @param initialMenuItem 初始化完成的 menuItem
 @param index Item 所属的位置
 @return 定制完成的 MenuItem
 */
- (HGMenuItem *)menuView:(HGMenuView *)menu initialMenuItem:(HGMenuItem *)initialMenuItem atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HGMenuView : UIView
@property(nonatomic, weak) id<HGMenuViewDelegate> delegate;
@property(nonatomic, weak) id<HGMenuViewDataSource> dataSource;
@property(nonatomic, assign) HGMenuViewStyle style;
@property(nonatomic, assign) HGMenuViewLayoutMode layoutMode;
@property(nonatomic, assign) CGFloat progressHeight;        //下划线进度条高度
@property(nonatomic, assign) CGFloat contentMargin;         //内部视图与左右的间距
@property(nonatomic, weak) UIScrollView *scrollView;
@property(nonatomic, weak) UIView *leftView;
@property(nonatomic, weak) UIView *rightView;
@property(nonatomic, assign) CGFloat progressViewBottomSpace;       //progressView 到 menuView 底部的距离
@property(nonatomic, strong) NSArray *progressWidths;       //定制进度条在各个 item 下的宽度
@property(nonatomic, weak) HGProgressView *progressView;

/**
 调皮效果，用于实现腾讯视频新效果，请设置一个较小的 progressWidth
 */
@property(nonatomic, assign) BOOL progressViewIsNaughty;

/**
 progressView的圆角
 */
@property(nonatomic, assign) CGFloat progressViewCornerRadius;
@property(nonatomic, copy) NSString *fontName;

/**
 进度条颜色
 */
@property(nonatomic, strong) UIColor *lineColor;
@property(nonatomic, assign) CGFloat speedFactor;   //进度条速度因数
@property(nonatomic, weak) HGMenuItem *selItem;
@property(nonatomic, assign) NSInteger selectIndex;

- (void)slideMenuAtProgress:(CGFloat)progress;
- (void)reload;
- (void)selectItemAtIndex:(NSInteger)index;
- (void)resetFrames;
- (void)refreshContentOffset;
- (void)deselectedItemsIfNeeded;

@end

NS_ASSUME_NONNULL_END
