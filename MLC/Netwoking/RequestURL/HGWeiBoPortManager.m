//
//  HGURLManager.m
//  HGSWB
//
//  Created by 黄刚 on 2018/10/27.
//  Copyright © 2018 HuangGang'sMac. All rights reserved.
//

#import "HGWeiBoPortManager.h"

#define WBBaseURL         @"https://api.weibo.com/2/"

@implementation HGWeiBoPortManager


+(NSString *)users_show{
    return [NSString stringWithFormat:@"%@users/show.json",WBBaseURL];
}

+ (NSString *)users_domain_show {
    return [NSString stringWithFormat:@"%@users/domain_show.json", WBBaseURL];
}
@end
