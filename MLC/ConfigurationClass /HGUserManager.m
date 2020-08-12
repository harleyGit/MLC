//
//  HGUserManager.m
//  HGSWB
//
//  Created by 黄刚 on 2018/7/14.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGUserManager.h"

@implementation HGUserManager
static HGUserManager *user = nil;

+ (instancetype) sharedInstance {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[super allocWithZone:nil] init];
    });
    return user;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return  [HGUserManager sharedInstance];
}

- (id) copyWithZone:(nullable NSZone *)zone {
    return [HGUserManager sharedInstance];
}

- (id)mutableCopyWithZone:(nullable NSZone *) zone {
    return [HGUserManager sharedInstance];
}

#pragma mark -- NSUserDefault
- (void)setUserID:(NSString *)userID{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:userID forKey:@"userID"];
}
- (NSString *)userID {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"userID"];
}


- (void)setUserName:(NSString *)userName {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:userName forKey:@"userName"];
}
- (NSString *)userName {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"userName"];
}


- (void)setUserNickName:(NSString *)userNickName {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:userNickName forKey:@"userNickName"];
}
- (NSString *)userNickName {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"userNickName"];
}


#pragma mark -- 微博字段
- (NSString *)access_token {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"access_token"];
}
- (void)setAccess_token:(NSString *)access_token {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:access_token forKey:@"access_token"];
}


- (NSString *)uid {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"uid"];
}
- (void)setUid:(NSString *)uid {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:uid forKey:@"uid"];
}

- (NSString *)domain {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"domain"];
}
- (void)setDomain:(NSString *)domain {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:domain forKey:@"domain"];
}



- (void) printPath {
    NSString *path = NSHomeDirectory();
    NSLog(@"NSUserDefaults 路径:%@", [NSString stringWithFormat:@"%@/Library/Preferences", path]);
}
@end
