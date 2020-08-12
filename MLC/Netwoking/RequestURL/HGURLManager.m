//
//  HGPortManager.m
//  HGSWB
//
//  Created by 黄刚 on 2019/1/12.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGPortManager.h"

#define TOUTIAO_BASE_URL            @"https://is.snssdk.com/"

@implementation HGPortManager

+ (NSString *)touTiaoHomeTitleURLString {
    return [NSString stringWithFormat:@"%@article/category/get_subscribed/v1/?",TOUTIAO_BASE_URL];
}

+ (NSString *)touTiaoHomeListURLString {
    return [self touTiaoVideoListURLString];
}

+ (NSString *)touTiaoVideoListURLString {
    return [NSString stringWithFormat:@"%@api/news/feed/v58/?",TOUTIAO_BASE_URL];
}

+ (NSString *)touTiaoVideoTitlesURLString {
    return [NSString stringWithFormat:@"%@video_api/get_category/v1/?",TOUTIAO_BASE_URL];
}

+ (NSString *)touTiaomMicroHeadlineURLString {
    return [NSString stringWithFormat:@"%@api/news/feed/v54/?", TOUTIAO_BASE_URL];
}

+ (NSString *)touTiaomMicroVideoURLString {
    return [NSString stringWithFormat:@"%@api/news/feed/v75/?", TOUTIAO_BASE_URL];
}

@end
