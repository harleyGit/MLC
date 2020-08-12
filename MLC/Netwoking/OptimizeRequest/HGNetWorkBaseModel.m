//
//  HGNetWorkBaseModel.m
//  HGSWB
//
//  Created by 黄刚 on 2019/1/13.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGNetWorkBaseModel.h"

#define request_timeOut_code    -1001
#define request_netWork_disconnection_code  -1009

@implementation HGNetWorkBaseModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _isPost = YES;
        _showNetErrorHUD = YES;
        _extraParameters = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (instancetype) netWorkModelWithURLString:(NSString *)urlString isPost:(BOOL)isPost {
    HGNetWorkBaseModel *model = [[self alloc] init];
    model.urlString = urlString;
    model.isPost = isPost;
    return model;
}

- (void)sendRequest {
    [self sendRequestWithSuccess:nil failure:nil];
}

- (void)sendRequestWithSuccess:(SuccessHanddle)success failure:(FailureHandle)failure {
    if (self.urlString.length == 0 || !self.urlString) {
        return;
    }
    
    NSMutableDictionary *params = [self params];
    if (self.isPost) {
        [HGNetWorkManager postRequestWithURLString:self.urlString parameters:params success:^(id  _Nonnull response) {
            if (success) {
                success(response);
            }
        } failure:^(NSError * _Nonnull error) {
            if (self->_showNetErrorHUD) {
                [self showNetWorkError:error];
            }
            if (failure) {
                failure(error);
            }
        }];
    }else {
        [HGNetWorkManager getRequestWithURLString:self.urlString parameters:params success:^(id  _Nonnull response) {
            if (success) {
                success(response);
            }
        } failure:^(NSError * _Nonnull error) {
            if (self->_showNetErrorHUD) {
                [self showNetWorkError:error];
            }
            if (failure) {
                failure(error);
            }
        }];
    }
}

//公共参数
- (NSMutableDictionary *)params {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addEntriesFromDictionary:self.extraParameters];
    [params addEntriesFromDictionary:self.mj_keyValues];//mj_keyValues 转换为字典
    
    if ([params.allKeys containsObject:@"isPost"]) {
        [params removeObjectForKey:@"isPost"];
    }
    
    if ([params.allKeys containsObject:@"urlString"]) {
        [params removeObjectForKey:@"urlString"];
    }
    
    if ([params.allKeys containsObject:@"showNetErrorHUD"]) {
        [params removeObjectForKey:@"showNetErrorHUD"];
    }
    
    if ([params.allKeys containsObject:@"extraParameters"]) {
        [params removeObjectForKey:@"extraParameters"];
    }
    
    for (id key in params.allKeys) {
        id obj = [params objectForKey:key];
        if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
            [params removeObjectForKey:key];
        }
    }
    return params;
}

- (void)showNetWorkError:(NSError *)error {
    if (error.code == request_timeOut_code) {
        [HGProgressHUD showError:@"请求超时"];
    }else if(error.code == request_netWork_disconnection_code){
        [HGProgressHUD showError:@"无法连接网络"];
    }else {
        NSString *errMsg = [NSString stringWithFormat:@"获取数据错误o(TωT)o(%ld)", error.code];
        [HGProgressHUD showError:errMsg];
    }
}

//重写打印输出格式：https://blog.csdn.net/yuner1029/article/details/50933945
- (NSString *)description {
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self params] options:NSJSONWritingPrettyPrinted error:nil];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
