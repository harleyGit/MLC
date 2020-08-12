//
//  HGNetWorkManager.h
//  HGSWB
//
//  Created by 黄刚 on 2019/1/12.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SuccessHanddle) (id response);
typedef void(^FailureHandle) (NSError *error);

@interface HGNetWorkManager : NSObject

+ (NSURLSessionDataTask *)postRequestWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters success:(SuccessHanddle)success failure:(FailureHandle)failure;

+ (NSURLSessionDataTask *)getRequestWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters success:(SuccessHanddle)success failure:(FailureHandle)failure;

@end

NS_ASSUME_NONNULL_END
