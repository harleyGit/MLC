//
//  HGMenuItem.h
//  HGSWB
//
//  Created by 黄刚 on 2019/1/3.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HGMenuItem;

typedef NS_ENUM(NSUInteger, HGMenuItemState) {
    HGMenuItemStateSelected,
    HGMenuItemStateNormal,
};

NS_ASSUME_NONNULL_BEGIN
@protocol HGMenuItemDelegate <NSObject>

@optional
- (void)didPressedMenuItem:(HGMenuItem *)menuItem;

@end

@interface HGMenuItem : UILabel

@property(nonatomic, nullable, weak) id<HGMenuItemDelegate> delegate;
@property(nonatomic, assign) CGFloat normalSize;        //Normal状态的字体大小，默认大小为15
@property(nonatomic, assign) CGFloat selectedSize;      //Selected状态的字体大小，默认大小为18

@property(nonatomic, strong) UIColor *normalColor;      //Normal状态的字体颜色，默认为黑色 (可动画)
@property(nonatomic, strong) UIColor *selecetedColor;       //Selected状态的字体颜色，默认为红色 (可动画)
@property(nonatomic, assign) CGFloat speedFactor;       //进度条的速度因数，默认 15，越小越快, 必须大于0
@property(nonatomic, assign, readonly) BOOL selected;
@property(nonatomic, assign) CGFloat rate;      //设置 rate, 并刷新标题状态 (0~1)

- (void)setSelected:(BOOL)selected withAnimation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
