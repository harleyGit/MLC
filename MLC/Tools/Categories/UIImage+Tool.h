//
//  UIImage+Tool.h
//  HGSWB
//
//  Created by 黄刚 on 2018/11/3.
//  Copyright © 2018 HuangGang'sMac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Tool)


/**
 颜色绘制为图片

 @param color 颜色
 @return 返回颜色图片
 */
+(UIImage *) imageWithColor:(UIColor *) color;


/**
 圆角图片绘制

 @param size 图片尺寸
 @param radius 圆角的数值
 @param backColor 图片填充色
 @param completion 完成图片block
 */
- (void) imageWithSize:(CGSize)size radius:(CGFloat)radius backColor:(UIColor *)backColor completion:(void (^)(UIImage *image))completion;

- (UIImage *)hn_drawRectWithRoundedCorner:(CGFloat)radius size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
