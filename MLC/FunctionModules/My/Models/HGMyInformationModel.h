//
//  HGMyInformationModel.h
//  HGSWB
//
//  Created by 黄刚 on 2018/11/6.
//  Copyright © 2018 HuangGang'sMac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGMyInformationModel : HGMyModel

//用户高清头像
@property(nonatomic, copy) NSString *avatar_hd;
//用户大图头像180*180
@property(nonatomic, copy) NSString *avatar_large;
//性别
@property(nonatomic, copy) NSString *gender;
//用户个人描述
@property(nonatomic, copy) NSString *introduction;  //description
@property(nonatomic, copy) NSString *location;
//关注数
@property(nonatomic, copy) NSString *friends_count;
//用户博客地址
@property(nonatomic, copy) NSString *url;


@end

NS_ASSUME_NONNULL_END
