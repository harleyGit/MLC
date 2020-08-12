//
//  HGAllNewsModel.h
//  HGSWB
//
//  Created by 黄刚 on 2018/8/7.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "SWModels.h"

@class HGEachNewsModel;
@interface HGAllNewsModel : SWModels

@property(nonatomic, assign) NSInteger count;
@property(nonatomic, copy)   NSString *first_id;
@property(nonatomic, copy)   NSString *last_id;
@property(nonatomic, retain) NSArray<HGEachNewsModel *> *news;


@end
