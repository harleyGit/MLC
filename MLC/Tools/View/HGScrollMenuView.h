//
//  HGScrollView.h
//  HGSWB
//
//  Created by 黄刚 on 2018/7/15.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HGSegmentHeaderType)
{
    HGSegmentHeaderTypeScroll,  //标签滚动
    HGSegmentHeaderTypeFixed    //标签固定
};

@interface HGScrollMenuView : UIView

@property(nonatomic, assign) CGFloat menuBarHeight;

@property(nonatomic, assign) CGFloat menuBarWidth;

@property(nonatomic, assign) CGFloat lineHeight;

@property(nonatomic, retain) UIImageView *scrollLine;

@property(nonatomic, assign) HGSegmentHeaderType headerType;



/**
 初始化UI和数据

 @param frame 分栏视图frame
 @param titles menu的题目
 @param views menu视图
 @return 实例对象
 */
- (instancetype) initWithFrame:(CGRect)frame titles:(NSArray *)titles contentViews:(NSArray *)views;

@end
