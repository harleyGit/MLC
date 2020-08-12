//
//  HGHomeNewsModel.m
//  HGSWB
//
//  Created by 黄刚 on 2019/2/8.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGHomeNewsModel.h"

@implementation HGHomeNewsImageModel

@end

@implementation HGHomeNewsModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data":@"HGHomeNewsSummaryModel"
             };
}

@end

@implementation HGHomeNewsInfoModel
//学习
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"image_list": @"HGHomeNewsImageModel"
             };
}

@end


@implementation HGHomeNewsSummaryModel

- (HGHomeNewsModel *)infoModel {
    if (_infoModel) {
        return _infoModel;
    }
    
    NSData *data = [self.content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    HGHomeNewsInfoModel  *model = [[HGHomeNewsInfoModel alloc] init];
    [model mj_setKeyValues:dic];
    _infoModel = model;
    return model;
}

@end
