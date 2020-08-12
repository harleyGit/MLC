//
//  HGPortManager.h
//  HGSWB
//
//  Created by 黄刚 on 2018/10/27.
//  Copyright © 2018 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGWeiBoPortManager : NSObject

//根据用户ID获取用户信息
+(NSString *)users_show;


/**
 http://open.weibo.com/wiki/2/users/domain_show

 @return 通过个性化域名获取用户资料以及用户最新的一条微博
 */
+ (NSString *)users_domain_show;

@end

NS_ASSUME_NONNULL_END
