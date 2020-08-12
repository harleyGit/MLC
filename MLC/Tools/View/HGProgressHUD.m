//
//  HGProgressHUD.m
//  SUPVP
//
//  Created by 黄刚 on 2018/7/11.
//  Copyright © 2018年 分赢信息. All rights reserved.
//

#import "HGProgressHUD.h"

//背景视图的大小
#define BGVIEW_WIDTH 100.0f
//文字大小
#define TEXT_SIZE 16.0f

@interface HGProgressHUD()
{
}
@end
@implementation HGProgressHUD
static HGProgressHUD *hud = nil;

+(instancetype)shareHUD {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[self alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    });
    return hud;
}

+ (void)showStatus:(HGProgressHUDStatus)status text:(NSString *)text {
    HGProgressHUD *HUD = [HGProgressHUD shareHUD];
    HUD.bezelView.color = [UIColor blackColor];
    HUD.contentColor = [UIColor whiteColor];
    [HUD showAnimated:YES];
    [HUD setShowNow:YES];
    //蒙版显示 YES， 不显示 NO
    //HUD.dimBackground = YES;
    HUD.label.text = text;
    HUD.label.textColor = [UIColor whiteColor];
    //隐藏时从视图移除掉
    [HUD setRemoveFromSuperViewOnHide:YES];
    HUD.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
    [HUD setMinSize:CGSizeMake(BGVIEW_WIDTH, BGVIEW_WIDTH)];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"YJProgressHUD" ofType:@"bundle"];
    
    switch (status) {
            
        case HGProgressHUDStatusSuccess: {
            
            NSString *sucPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Success.png"];
            UIImage *sucImage = [UIImage imageWithContentsOfFile:sucPath];
            
            HUD.mode = MBProgressHUDModeCustomView;
            UIImageView *sucView = [[UIImageView alloc] initWithImage:sucImage];
            HUD.customView = sucView;
            [HUD hideAnimated:YES afterDelay:2.0f];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HUD setShowNow:NO];
            });
        }
            break;
            
        case HGProgressHUDStatusError: {
            
            NSString *errPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Error.png"];
            UIImage *errImage = [UIImage imageWithContentsOfFile:errPath];
            
            HUD.mode = MBProgressHUDModeCustomView;
            UIImageView *errView = [[UIImageView alloc] initWithImage:errImage];
            HUD.customView = errView;
            [HUD hideAnimated:YES afterDelay:2.0f];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HUD setShowNow:NO];
            });
        }
            break;
            
        case HGProgressHUDStatusLoating: {
            HUD.mode = MBProgressHUDModeIndeterminate;
        }
            break;
            
            
        case HGProgressHUDStatusWaitting: {
            NSString *infoPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Warn.png"];
            UIImage *infoImage = [UIImage imageWithContentsOfFile:infoPath];
            
            HUD.mode = MBProgressHUDModeCustomView;
            UIImageView *infoView = [[UIImageView alloc] initWithImage:infoImage];
            HUD.customView = infoView;
            [HUD hideAnimated:YES afterDelay:2.0f];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HUD setShowNow:NO];
            });
            
        }
            break;
            
        case HGProgressHUDStatusInfo: {
            
            NSString *infoPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Info.png"];
            UIImage *infoImage = [UIImage imageWithContentsOfFile:infoPath];
            
            HUD.mode = MBProgressHUDModeCustomView;
            UIImageView *infoView = [[UIImageView alloc] initWithImage:infoImage];
            HUD.customView = infoView;
            [HUD hideAnimated:YES afterDelay:2.0f];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HUD setShowNow:NO];
            });
        }
            break;
            
        default:
            break;
    }
}

+ (void)showMessage:(NSString *)text {
    
    HGProgressHUD *HUD = [HGProgressHUD shareHUD];
    HUD.bezelView.color = [UIColor blackColor];
    [HUD showAnimated:YES];
    [HUD setShowNow:YES];
    HUD.label.text = text;
    HUD.contentColor=[UIColor whiteColor];
    [HUD setMinSize:CGSizeZero];
    [HUD setMode:MBProgressHUDModeText];
    //    HUD.dimBackground = YES;
    [HUD setRemoveFromSuperViewOnHide:YES];
    HUD.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[HGProgressHUD shareHUD] setShowNow:NO];
        [[HGProgressHUD shareHUD] hideAnimated:YES];
    });
}

+ (void)showWaiting:(NSString *)text {
    
    [self showStatus:HGProgressHUDStatusWaitting text:text];
}

+ (void)showError:(NSString *)text {
    
    [self showStatus:HGProgressHUDStatusError text:text];
}

+ (void)showSuccess:(NSString *)text {
    
    [self showStatus:HGProgressHUDStatusSuccess text:text];
}

+ (void)showLoading:(NSString *)text {
    
    [self showStatus:HGProgressHUDStatusLoating text:text];
}

+ (void)hideHUD {
    
    [[HGProgressHUD shareHUD] setShowNow:NO];
    [[HGProgressHUD shareHUD] hideAnimated:YES];
}


@end
