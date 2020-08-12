//
//  HGVideoListModel.m
//  HGSWB
//
//  Created by 黄刚 on 2019/2/3.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGVideoListModel.h"

@implementation HGVideoListModel

@end


@implementation HGVideoDetailModel

- (HGVideoPlayInfoModel *)videoInfoModel {
    if (!_videoInfoModel) {
        NSData *data = [self.video_play_info dataUsingEncoding:NSUTF8StringEncoding];
        if (!data) {
            return nil;
        }else {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            _videoInfoModel = [[[HGVideoPlayInfoModel alloc] init] mj_setKeyValues:dic];
        }
    }
    return _videoInfoModel;
}

@end


@implementation HGVideoPlayInfoModel


@end


@implementation HGVideoUserInfoModel



@end


@implementation HGVideoURLLevelModel



@end
