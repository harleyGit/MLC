//
//  HGProgressView.h
//  HGSWB
//
//  Created by 黄刚 on 2019/1/1.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGProgressView : UIView

@property(nonatomic, strong) NSArray *itemFrames;
@property(nonatomic, assign) CGColorRef color;
// 调皮属性，用于实现新腾讯视频效果
@property(nonatomic, assign) BOOL naughty;
//圆角设置
@property(nonatomic, assign) CGFloat cornerRadius;
@property(nonatomic, assign) CGFloat progress;

/**
 进度条的速度因数，默认为 15，越小越快， 大于 0
 */
@property(nonatomic, assign) CGFloat speedFactor;
@property(nonatomic, assign) BOOL hollow;
@property(nonatomic, assign) BOOL hasBorder;
@property(nonatomic, assign) BOOL isTriangle;

- (void) moveToPostion:(NSInteger)pos;
- (void) setProgressWithOutAnimate:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
