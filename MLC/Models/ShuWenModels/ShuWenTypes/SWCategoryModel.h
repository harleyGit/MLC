//
//  SWCategory.h
//  HGSWB
//
//  Created by 黄刚 on 2018/7/14.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "JSONModel.h"

@protocol SWCategoryModel
@end

@interface SWCategoryModel : JSONModel

@property(nonatomic, copy) NSString *alias;
@property(nonatomic, copy) NSString *name;

@end
