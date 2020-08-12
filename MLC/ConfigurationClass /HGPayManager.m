//
//  HGPayManager.m
//  HGSWB
//
//  Created by 黄刚 on 2018/9/4.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGPayManager.h"

@implementation HGPayManager
static HGPayManager *payManager;

+ (id) sharePayManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        payManager = [[super alloc] init];
    });
    return payManager;
}


- (void) handleOrderAliPayWithParams:(NSDictionary *) parameters {
    NSLog(@"parameters: %@", parameters);
    
    NSString *appScheme = @"alisdkofshuyinHotel";
    NSString *orderString = parameters[@"payInfo"];
    
    //NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@", resultDic);
        
        int statusCode = [resultDic[@"resultStatus"] intValue];
        if (statusCode == 900) {
            //订单支付
            [HGProgressHUD showSuccess:@"支付成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
        }else {
            [HGProgressHUD showError:@"支付异常"];
        }
    }];
}

@end
