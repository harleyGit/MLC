//
//  HGMyPresent.m
//  HGSWB
//
//  Created by 黄刚 on 2018/9/5.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGMyPresent.h"

@interface HGMyPresent()

@end

@implementation HGMyPresent

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


+ (void) loadDataForUser_show {
    HGUserManager *um = [HGUserManager sharedInstance];
    NSString *access_token = um.access_token;
    NSString *uid = um.uid;
    HGNetworking *nw = [HGNetworking shareInstance];
    nw.delegate = self;
    
    [HGNetworking requestMethodType:RequestMethodTypeGet url:[HGWeiBoPortManager users_show] parameters:@{@"access_token": access_token, @"uid": uid}];
}

- (void)requestData:(NSData *)data {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    self.myModel = [[HGMyModel alloc] initWithString:string error:nil];
}

- (void) loadDataFor_UsersDomain_show{
    HGUserManager *user = [HGUserManager sharedInstance];
    HGNetworking *networking = [HGNetworking shareInstance];
    
    [HGNetworking requestMethodType:RequestMethodTypeGet url:[HGWeiBoPortManager users_domain_show] parameters:@{@"access_token":user.access_token, @"domain":user.domain}];
    
    networking.requestSuccess = ^(id successData) {
        id jsonData = [NSJSONSerialization JSONObjectWithData:successData options:NSJSONReadingMutableContainers error:nil];
        if ([self.delegate respondsToSelector:@selector(switchToJSONForData:)]) {
            [self.delegate switchToJSONForData:jsonData];
        }
    };
    networking.requestFail = ^(id failData) {
        [self.delegate switchToJSONForData:failData];
    };
}
@end
