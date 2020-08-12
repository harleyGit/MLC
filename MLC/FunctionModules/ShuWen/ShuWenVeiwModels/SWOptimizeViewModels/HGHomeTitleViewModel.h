//
//  HGHomeTitleViewModel.h
//  HGSWB
//
//  Created by 黄刚 on 2019/1/13.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGHomeTitleViewModel : HGBaseViewModel

//ReactiveObjC 第三方类库
@property(nonatomic, strong) RACCommand *titlesCommand;

@end

NS_ASSUME_NONNULL_END
