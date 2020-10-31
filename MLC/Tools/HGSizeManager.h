//
//  HGSizeManager.h
//  MLC
//
//  Created by Harley Huang on 31/10/2020.
//  Copyright © 2020 HuangGang'sMac. All rights reserved.
//
/**
 *作用：尺码管理器
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGSizeManager : NSObject

//左边距
+ (float) marginLeft;
//右边距
+ (float) marginRight;
//上边距
+ (float) marginTop;
//下边距
+ (float) marginBottom;

@end

NS_ASSUME_NONNULL_END
