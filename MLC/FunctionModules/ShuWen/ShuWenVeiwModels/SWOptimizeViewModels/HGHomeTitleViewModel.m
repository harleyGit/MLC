//
//  HGHomeTitleViewModel.m
//  HGSWB
//
//  Created by 黄刚 on 2019/1/13.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGHomeTitleViewModel.h"

@implementation HGHomeTitleViewModel

- (instancetype) init{
    self = [super init];
    if (self) {
        _titlesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                HGHomeTitleRequest *request = [HGHomeTitleRequest netWorkModelWithURLString:HGPortManager.touTiaoHomeTitleURLString isPost:NO];
                request.iid = HN_IID;
                request.device_id = HN_DEVICE_ID;
                request.aid = [input intValue];
                
                [request sendRequestWithSuccess:^(id  _Nonnull response) {
                    NSDictionary *responseDic = (NSDictionary *)response;
                    responseDic = responseDic[@"data"];
                    NSMutableArray *models = [NSMutableArray array];
                    if (responseDic.count > 0) {
                        NSArray *dicArr = responseDic[@"data"];
                        for (int i = 0; i < [dicArr count]; i ++) {
                            NSLog(@"homeTitle JSON数据为： %@", dicArr[i]);
                            HGHomeTitleModel *model = [[HGHomeTitleModel new] mj_setKeyValues:dicArr[i]];
                            [models addObject:model];
                        }
                        [subscriber sendNext:models];
                        //订阅完成
                        [subscriber sendCompleted];
                    }else {
                        [HGProgressHUD showError:HG_ERROR_SERVER];
                    }
                } failure:^(NSError * _Nonnull error) {
                    //do Error NSLog
                }];
                return nil;
            }];
        }];
    }
    return self;
}


@end
