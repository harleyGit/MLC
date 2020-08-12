//
//  HGMyInformationModel.m
//  HGSWB
//
//  Created by 黄刚 on 2018/11/6.
//  Copyright © 2018 HuangGang'sMac. All rights reserved.
//

#import "HGMyInformationModel.h"


@implementation HGMyInformationModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"introduction"}];
}

@end
