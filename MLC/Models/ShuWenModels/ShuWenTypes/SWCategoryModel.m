//
//  SWCategory.m
//  HGSWB
//
//  Created by 黄刚 on 2018/7/14.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "SWCategoryModel.h"

@implementation SWCategoryModel

//key值的change
+ (JSONKeyMapper *)keyMapper {
    return  [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"_alias": @"alias", @"_name": @"name"}];
}

//设置所有的属性为可选(所有属性值可以为空)
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
