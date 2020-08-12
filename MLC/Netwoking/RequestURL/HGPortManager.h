//
//  HGPortManager.h
//  HGSWB
//
//  Created by 黄刚 on 2019/1/12.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TOUTIAO_KHomeStopRefreshNot         @"homeStopRefreshNot"

NS_ASSUME_NONNULL_BEGIN

@interface HGPortManager : NSObject

#pragma MARK -- 头条URL
+ (NSString *)touTiaoHomeTitleURLString;
+ (NSString *)touTiaoHomeListURLString;
+ (NSString *)touTiaoVideoTitlesURLString;
+ (NSString *)touTiaoVideoListURLString;
+ (NSString *)touTiaomMicroHeadlineURLString;
+ (NSString *)touTiaomMicroVideoURLString;

@end

NS_ASSUME_NONNULL_END
