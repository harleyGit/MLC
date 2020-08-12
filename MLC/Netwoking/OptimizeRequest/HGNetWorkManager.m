//
//  HGNetWorkManager.m
//  HGSWB
//
//  Created by 黄刚 on 2019/1/12.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGNetWorkManager.h"

static const float timeOut = 10.0f;

@implementation HGNetWorkManager

+ (AFHTTPSessionManager *)manager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //表示以json形式，返回数据，默认为该样式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = timeOut;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];    //请求数据类型
    return manager;
}

+ (NSURLSessionDataTask *)postRequestWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters success:(SuccessHanddle)success failure:(FailureHandle)failure {
    //对汉字进行转码
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [self.manager POST:URLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (NSURLSessionDataTask *)getRequestWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters success:(SuccessHanddle)success failure:(FailureHandle)failure {
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [self.manager GET:URLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end
