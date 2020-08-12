//
//  HGHomeJokeInfoModel.m
//  HGSWB
//
//  Created by 黄刚 on 2019/2/8.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGHomeJokeInfoModel.h"

@implementation HGHomeJokeInfoModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _comment_count = 30;
        _star_count = 120;
        _hate_count = 36;
    }
    return self;
}

+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"comment_count", @"star_count", @"hate_count"];
}

@end


@implementation HGHomeJokeModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data": @"HGHomeJokeSummaryModel"
             };
}

@end


@implementation HGHomeJokeSummaryModel

- (HGHomeJokeInfoModel *)infoModel {
    if (_infoModel) {
        return _infoModel;
    }
    
    NSData *data = [self.content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    HGHomeJokeInfoModel *model = [HGHomeJokeInfoModel new];
    [model mj_setKeyValues:dic];
    _infoModel = model;
    return model;
}

@end
