//
//  HGHomeNewsCellViewModel.h
//  HGSWB
//
//  Created by 黄刚 on 2019/2/3.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGHomeNewsCellViewModel : HGBaseViewModel

@property(nonatomic, strong) RACCommand *newsCommand;

@end

NS_ASSUME_NONNULL_END
