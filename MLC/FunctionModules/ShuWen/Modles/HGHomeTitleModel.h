//
//  HGHomeTitleModel.h
//  HGSWB
//
//  Created by 黄刚 on 2019/1/2.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHomeTitleModel : NSObject

@property(nonatomic, copy) NSString *category;

@property(nonatomic, copy) NSString *concern_id;

@property(nonatomic, assign) int default_add;

@property(nonatomic, assign) int flags;

@property(nonatomic, copy) NSString *icon_url;

@property(nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
