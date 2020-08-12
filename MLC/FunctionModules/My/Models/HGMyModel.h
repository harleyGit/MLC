//
//  HGMyModel.h
//  HGSWB
//
//  Created by 黄刚 on 2018/9/5.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGWBBaseModel.h"

@interface HGMyModel : HGWBBaseModel

//友好显示昵称
@property(nonatomic, copy) NSString *name;
//粉丝数
@property(nonatomic,copy) NSString *followers_count;
//用户头像地址(中图),50*50像素
@property(nonatomic, copy) NSString *profile_image_url;

@end
