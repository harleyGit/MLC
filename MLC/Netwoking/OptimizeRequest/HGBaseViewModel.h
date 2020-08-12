//
//  HGBaseViewModel.h
//  HGSWB
//
//  Created by 黄刚 on 2019/1/13.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HG_ERROR_SERVER                         @"服务器开小差了！"

NS_ASSUME_NONNULL_BEGIN

@interface HGBaseViewModel : NSObject

- (void) bindView:(UIView *)view;
- (void) bindTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
