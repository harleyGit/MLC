//
//  HGHomeTitleRequest.h
//  HGSWB
//
//  Created by 黄刚 on 2019/1/13.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGNetWorkBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGHomeTitleRequest : HGNetWorkBaseModel

@property(nonatomic, copy) NSString *iid;
@property(nonatomic, copy) NSString *device_id;
@property(nonatomic, assign) int aid;

@end

NS_ASSUME_NONNULL_END
