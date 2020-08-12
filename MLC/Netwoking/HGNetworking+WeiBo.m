//
//  HGNetworking+WeiBo.m
//  HGSWB
//
//  Created by 黄刚 on 2018/8/29.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGNetworking+WeiBo.h"

@implementation HGNetworking (WeiBo)
//static修饰全局变量，让外界文件无法访问
static HGNetworking *networking = nil;

+ (instancetype) shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networking = [HGNetworking new];
    });
    return networking;
}

- (void)requestMethodType:(RequestMethodType)methodType url:(NSString *)url parameters:(NSDictionary *)parameters {
    [[[HGNetworking shareInstance] class] requestMethodType:methodType url:url parameters:parameters];
}

+ (void) requestMethodType:(RequestMethodType)methodType url:(NSString *)url parameters:(NSDictionary *)parameters {
    
    switch (methodType) {
        case RequestMehtodTypePost:
            [HGNetworking urlOfPostRequest:url parameters:parameters];
            break;
        case RequestMethodTypeGet:
        [HGNetworking urlOfGetRequest:url parameters:parameters];
            break;
            
        default:
            break;
    }
}

#pragma mark -- POST
+ (void) urlOfPostRequest:(NSString *)url parameters:(NSDictionary *) parameters {
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    request.HTTPMethod      = @"POST";
    NSString *parametersStr = [HGNetworking joiningTogetherOfparameters:parameters];
    request.HTTPBody        = [parametersStr dataUsingEncoding: NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //传递数据
        [HGNetworking passResponseOfSuccessData:data withFailError:error];
        
    }];
    
    [dataTask resume];
}

#pragma mark-- GET
+ (void) urlOfGetRequest:(NSString *)url parameters:(NSDictionary *) parameters{
    NSString *parametersStr = [HGNetworking joiningTogetherOfparameters: parameters];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", url, parametersStr]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //传递数据,这里在后台线程中
        dispatch_async(dispatch_get_main_queue(), ^{
            [HGNetworking passResponseOfSuccessData:data withFailError:error];
        });
    }];
    
    [task resume];
}

#pragma  mark -- 参数拼接
+ (NSString *) joiningTogetherOfparameters:(NSDictionary *)parameters {
    NSMutableString *parametersStr = [NSMutableString new];
    
    int i = 0;
    for (NSString *key in parameters.allKeys) {
        [parametersStr appendFormat:@"%@=%@", key, parameters[key]];
        if (i < parameters.allKeys.count - 1) {
            [parametersStr appendString:@"&"];
        }
        i ++;
    }
    
    return parametersStr;
}

#pragma mark -- 传递数据
+ (void) passResponseOfSuccessData:(NSData *) data withFailError:(NSError *) error{
    HGNetworking *network = [HGNetworking shareInstance];
    if (network.delegate && [network.delegate respondsToSelector:@selector(requestData:)]) {
        [network.delegate requestData:data];
    }
    
    //数据没有出错
    if (!error) {
        if (network.requestSuccess) {
            network.requestSuccess(data);
        }
    }else {
        if (network.requestFail) {
            network.requestFail(error);
        }
    }
    
    
}

- (void)dealloc {
    NSLog(@"------>> 无泄漏");
}
@end
