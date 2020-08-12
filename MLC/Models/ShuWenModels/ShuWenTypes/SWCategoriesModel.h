//
//  SWCategoriesModel.h
//  HGSWB
//
//  Created by 黄刚 on 2018/7/14.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "JSONModel.h"
@class SWCategoryModel;
@interface SWCategoriesModel : SWModels

//尖括号后 NSArray 包含一个协议. 这跟Objective-C原生的泛型不是一个概念. 他们不会冲突, 但对于JSONModel来说,协议必须在一个地方声明.
@property(nonatomic, strong) NSMutableArray<SWCategoryModel*>* categories;

@end
