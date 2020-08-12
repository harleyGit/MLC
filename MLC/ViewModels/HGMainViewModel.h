//
//  HGMainViewModel.h
//  HGSWB
//
//  Created by 黄刚 on 2018/8/3.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ SuccessModel) (id model);

@interface HGMainViewModel : NSObject

@property(nonatomic, copy) SuccessModel  successModel;

@end
