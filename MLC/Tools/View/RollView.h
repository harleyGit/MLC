//
//  RollView.h
//  MLC
//
//  Created by 黄刚 on 2019/12/13.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 设置代理 */
@protocol RollViewDelegate <NSObject>

-(void)didSelectPicWithIndexPath:(NSInteger)index;

@end

@interface RollView : UIView

@property (nonatomic, assign) id<RollViewDelegate> delegate;

/**
 初始化
 
 @param frame 设置View大小
 @param distance 设置Scroll距离View两侧距离
 @param gap 设置Scroll内部 图片间距
 @return 初始化返回值
 */
- (instancetype)initWithFrame:(CGRect)frame withDistanceForScroll:(float)distance withGap:(float)gap;

/** 滚动视图数据 */
-(void)rollView:(NSArray *)dataArr;

@end

NS_ASSUME_NONNULL_END
