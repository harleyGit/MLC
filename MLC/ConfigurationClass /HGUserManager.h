//
//  HGUserManager.h
//  HGSWB
//
//  Created by 黄刚 on 2018/7/14.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGUserManager : NSObject

@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *userNickName;
@property(nonatomic, copy) NSString *userID;

#pragma mark -- 微博关键字段
@property(nonatomic, copy) NSString *access_token;
@property(nonatomic, copy) NSString *uid;
//个性化域名
@property(nonatomic, copy) NSString *domain;



+ (instancetype) sharedInstance;
- (void) printPath;

@end
