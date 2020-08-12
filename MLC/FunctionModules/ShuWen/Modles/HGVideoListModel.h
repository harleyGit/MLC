//
//  HGVideoListModel.h
//  HGSWB
//
//  Created by 黄刚 on 2019/2/3.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HGVideoDetailModel;

@interface HGVideoListModel : NSObject

@property(nonatomic, copy)  NSString *code;
@property(nonatomic, copy)  NSString *content;
@property(nonatomic, strong)    HGVideoDetailModel *videoModel;
@property(nonatomic, assign)    BOOL playing;

@end

@interface HGVideoURLInfoModel : NSObject

@property(nonatomic, copy)  NSString *main_url;
@property(nonatomic, copy)  NSString *back_url_1;

@end



@interface HGVideoURLLevelModel : NSObject

@property(nonatomic, strong)    HGVideoURLInfoModel *video_1;  //320P
@property(nonatomic, strong)    HGVideoURLInfoModel *video_2;  //480P
@property(nonatomic, strong)    HGVideoURLInfoModel *video_3;   //720P

@end


@interface HGVideoPlayInfoModel : NSObject

@property(nonatomic, assign)    float video_duration;
@property(nonatomic, copy)  NSString *poster_url;
@property(nonatomic, strong)    HGVideoURLLevelModel *video_list;

@end

@interface HGVideoUserInfoModel : NSObject

@property(nonatomic, copy)  NSString *avatar_url;

@end


@interface HGVideoDetailModel : NSObject

@property(nonatomic, copy)  NSString *media_name;
@property(nonatomic, copy)  NSString *title;
@property(nonatomic, copy)  NSString *video_play_info;
@property(nonatomic, strong)    HGVideoPlayInfoModel *videoInfoModel;
@property(nonatomic, strong)    HGVideoUserInfoModel *user_info;

@end


NS_ASSUME_NONNULL_END
