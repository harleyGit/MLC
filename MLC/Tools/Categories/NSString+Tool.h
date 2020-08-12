//
//  NSString+Tool.h
//  HGSWB
//
//  Created by 黄刚 on 2018/11/6.
//  Copyright © 2018 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Tool)


/// 分类添加属性(使用运行时)
@property(nonatomic, copy)NSString *name;


/**
 url 字符串转化为NSData

 @param urlStr url字符串
 @return 返回NSData数类型
 */
+ (NSData *) switchToDataForURLString:(NSString *) urlStr;

@end

NS_ASSUME_NONNULL_END
