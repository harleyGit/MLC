//
//  HGNetworking+WeiBo.h
//  HGSWB
//
//  Created by 黄刚 on 2018/8/29.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGNetworking.h"

#pragma mark -- 请求类型
typedef NS_ENUM(NSInteger, RequestMethodType){
    RequestMehtodTypePost,
    RequestMethodTypeGet,
    RequestMethodTypeDelete,
    RequestMethodTypeUpdate,
};


@interface HGNetworking (WeiBo)

+ (instancetype) shareInstance;

/**
 请求数据

 @param methodType GET、POST、Delete、Update 强求数据类型
 @param url 接口地址
 @param parameters 接口参数
 */
- (void)requestMethodType:(RequestMethodType)methodType url:(NSString *)url parameters:(NSDictionary *)parameters;

+ (void) requestMethodType:(RequestMethodType)methodType url:(NSString *)url parameters:(NSDictionary *)parameters;

@end
