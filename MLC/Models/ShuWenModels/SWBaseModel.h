//
//  SWBaseModel.h
//  HGSWB
//
//  Created by 黄刚 on 2018/7/14.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "JSONModel.h"

@interface SWBaseModel : JSONModel

@property(nonatomic, assign) int success;
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *msg;
@property(nonatomic, strong) NSDictionary *data;
@property(nonatomic, copy) NSString *requestId;

@end
