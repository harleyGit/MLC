//
//  HGFunctionVM.m
//  HGSWB
//
//  Created by 黄刚 on 2018/8/3.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGFunctionVM.h"

@implementation HGFunctionVM

- (instancetype)initWithSuccessModel:(SuccessModel)successM {
    self = [super init];
    if (self) {
        self.successModel = [successM copy];
    }
    return self;
}

- (void) returenModel {
    NSString *port = @"category?";
    NSString *baseUrl = [HGNetworking shuWenPortUrl: port parameters:nil];
    NSString *url = [NSString stringWithFormat: @"%@", baseUrl];
    [HGNetworking requestWithUrl:url success:^(SWBaseModel *successModel) {
        if (successModel) {
            NSDictionary *categoriesDic = successModel.data;
             NSMutableArray *categories = [SWCategoryModel arrayOfModelsFromDictionaries:categoriesDic[@"categories"] error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.successModel) {
                    self.successModel(categories);
                }
            });
        } 
    } failure:^(NSError *error) {
        NSLog(@"--------->> %@", error);
    }];
}




@end
