//
//  HGHomeNewsRequest.h
//  HGSWB
//
//  Created by 黄刚 on 2019/2/3.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGNetWorkBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGHomeNewsRequest : HGNetWorkBaseModel

@property(nonatomic, copy)NSString *category;
@property(nonatomic, copy)NSString *device_id;
@property(nonatomic, copy)NSString *iid;
@property(nonatomic, copy)NSString *device_platform;
@property(nonatomic, copy)NSString *version_code;

@end

NS_ASSUME_NONNULL_END
