//
//  HGProgressHUD.h
//  SUPVP
//
//  Created by 黄刚 on 2018/7/11.
//  Copyright © 2018年 分赢信息. All rights reserved.
//

#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, HGProgressHUDStatus){
//    成功
    HGProgressHUDStatusSuccess,
//    失败
    HGProgressHUDStatusError,
//    警告
    HGProgressHUDStatusWaitting,
//    提示
    HGProgressHUDStatusInfo,
//    等待
    HGProgressHUDStatusLoating
};

@interface HGProgressHUD : MBProgressHUD
@property(nonatomic, assign, getter=isShowNow) BOOL showNow;

+(instancetype) shareHUD;
//window 上添加一个HUD
+(void) showStatus:(HGProgressHUDStatus)status text:(NSString *) text;

#pragma mark - 建议使用的方法
+ (void) showSuccess:(NSString *) text;
+ (void) showError:(NSString *) text;
+ (void) showWaiting:(NSString *)text;
+ (void) showLoading:(NSString *)text;

+ (void) hideHUD;
@end
