//
//  HGHomeNewsCellViewModel.m
//  HGSWB
//
//  Created by 黄刚 on 2019/2/3.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGHomeNewsCellViewModel.h"

@implementation HGHomeNewsCellViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _newsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                HGHomeNewsRequest *request = [HGHomeNewsRequest netWorkModelWithURLString:HGPortManager.touTiaoHomeListURLString isPost:NO];
                request.device_id = HN_DEVICE_ID;
                request.iid = HN_IID;
                request.version_code = @"6.2.7";
                request.device_platform = @"iphone";
                request.category = input;
                [request sendRequestWithSuccess:^(id  _Nonnull response) {
                    NSDictionary *responseDic = (NSDictionary *)response;
                    if ([input isEqualToString:@"essay_joke"]) {
                        HGHomeJokeModel *model = [[HGHomeJokeModel alloc] init];
                        [model mj_setKeyValues:responseDic];
                        [model.data makeObjectsPerformSelector:@selector(infoModel)];
                        [subscriber sendNext:model];
                        [subscriber sendCompleted];
                    }else if ([input isEqualToString:@"video"]){
                        NSArray *dataArr = responseDic[@"data"];
                        NSMutableArray *models = [[NSMutableArray alloc] init];
                        for (int i = 0; i < dataArr.count; i ++) {
                            HGVideoListModel *model = [[[HGVideoListModel alloc] init] mj_setKeyValues:dataArr[i]];
                            [[model videoModel] videoInfoModel];
                            [models addObject:model];
                        }
                        [subscriber sendNext:models];
                        [subscriber sendCompleted];
                    }else {
                        HGHomeNewsModel *model = [[HGHomeNewsModel alloc] init];
                        [model mj_setKeyValues:responseDic];
                        [model.data makeObjectsPerformSelector:@selector(infoModel)];
                        [subscriber sendNext:model];
                        [subscriber sendCompleted];
                    }
                } failure:^(NSError * _Nonnull error) {
                    // 错误处理
                    NSLog(@"HGHomeNewsCellViewModel: %@", error);
                }];
                return nil;
            }];
        }];
    }
    return self;
}

@end
