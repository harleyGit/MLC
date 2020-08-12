//
//  UIImage+Tool.m
//  HGSWB
//
//  Created by 黄刚 on 2018/11/3.
//  Copyright © 2018 HuangGang'sMac. All rights reserved.
//

#import "UIImage+Tool.h"

@implementation UIImage (Tool)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    //创建一个基于位图的上下文（context）,并将其设置为当前上下文(context)。
    UIGraphicsBeginImageContext(rect.size);
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置填充颜色
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //填充矩形
    CGContextFillRect(context, rect);
    //获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    //结束上下文
    UIGraphicsEndImageContext();
    return theImage;
}


- (void) imageWithSize:(CGSize)size radius:(CGFloat)radius backColor:(UIColor *)backColor completion:(void (^)(UIImage *image))completion {
    //异步绘制裁切
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //绘图建立上下文
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        //填充颜色
        [backColor setFill];
        UIRectFill(rect);
        
        //贝塞尔裁切
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
        //一个path调用addClip之后，它所在的context的可见区域就变成了它的“fill area”，接下来的绘制，如果在这个区域外都会被无视。
        [path addClip];
        //drawInRect是以rect作为图片绘制的区域，图片是以填充的方式被绘制在当前区域图片的大小，rect的宽高比和原图片的宽高比不同时会造成图片的变形
        [self drawInRect:rect];
        
        //获取结果
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        //关闭上下文
        UIGraphicsEndImageContext();
        
        //主队列回调
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(resultImage);
        });
    });
}

- (UIImage *)hn_drawRectWithRoundedCorner:(CGFloat)radius size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    //用来处理图片的图形上下文,函数不仅仅是创建了一个适用于图形操作的上下文，并且该上下文也属于当前上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, false, [UIScreen mainScreen].scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [self drawInRect:rect];
    
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
