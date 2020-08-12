//
//  HGTools.h
//  HGSWB
//
//  Created by 黄刚 on 2018/7/8.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//修改图片尺寸：https://www.jianshu.com/p/ba45f5539e4e
//图形上下文详解：https://www.jianshu.com/p/ad8eed568ff4， https://www.jianshu.com/p/be38212c0f79


#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, SecondType) {
    SecondType_Second = 0,  //秒
    SecondType_Millisecond, //毫秒
    SecondType_Nanosecond   //纳秒
};

typedef NS_ENUM(NSInteger, PictureTypes) {
    PictureTypes_PNG,       //.png 图片
    PictureTypes_GIF        //.gif
    
};

@interface HGTools : NSObject

#pragma mark -- 字符串为空值
+ (BOOL) isBlankForString:(NSString *) str ;

#pragma mark - URL获得图片尺寸
+(CGSize) pngImageSizeWithURL:(id) imageURL;

#pragma mark -- 自定义缩放图片尺寸
+ (CGSize) scaleImage:(UIImage *) image toSize:(CGSize)newSize;

#pragma mark - 获得数闻签名
+ (NSString *)SWSignatureForTime: (NSString *)timeStamp;

#pragma mark - 获取时间戳
+ (NSString *)currentTimestamp:(SecondType) secondType;

#pragma mark -- 时间戳转化为时间
+ (NSString *) changeTimeFormatForTiemstamp:(NSString *)time;


//将url字符串转化为NSData数据
+ (NSData *) transformToDataForURLString:(NSString *)urlStr;



/**
 浏览大图

 @param currentImageview 放大的UIImageView
 @param alpha 背景透明度
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview alpha:(CGFloat)alpha;

@end
