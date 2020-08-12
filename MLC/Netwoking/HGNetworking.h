//
//  HGNetworking.h
//  HGSWB
//
//  Created by 黄刚 on 2018/7/7.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef struct  ShuWenData {
    char *baseUrl;
    char *timeStamp;
    char *signature;
}ShuWenData;

typedef void (^RequestSuccess) (id successData);
typedef void (^RequestFail)    (id failData);

@protocol HGNetworkingDelegate<NSObject>

@required

@optional
- (void) requestData:(NSData *)data;

@end

@interface HGNetworking : NSObject

#pragma mark -- 属性
@property(nonatomic, weak) id<HGNetworkingDelegate>  delegate;
@property(nonatomic, assign) ShuWenData            shuWenData;
@property(nonatomic, copy)   RequestSuccess        requestSuccess;
@property(nonatomic, copy)   RequestFail           requestFail;


#pragma mark -- 方法
//数闻基础URL配置
+ (NSString *) shuWenPortUrl:(NSString *)port  parameters:(NSDictionary *) parameters;

+ (void) requestWithUrl:(NSString *) url success:(void (^)(id successModel))success failure:(void (^)(NSError *error))failure ;

@end
