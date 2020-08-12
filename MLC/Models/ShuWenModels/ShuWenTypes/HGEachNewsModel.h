//
//  HGEachNews.h
//  HGSWB
//
//  Created by 黄刚 on 2018/8/7.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "SWModels.h"

@interface HGEachNewsModel : SWModels
//注意：若解析的JSON字段为空，但是定义的Model属性不为空，则初始化的Model对象则为空
@property(nonatomic, copy)      NSArray<NSString *> *category;
//新闻文本内容
@property(nonatomic, copy)      NSString<Optional>  *content;
//发布时间
@property(nonatomic, copy)      NSString            *gmt_publish;
//热门指数
@property(nonatomic, copy)      NSString            *hot_index;
//新闻ID
@property(nonatomic, copy)      NSString            *news_id;
@property(nonatomic, assign)    NSInteger           selection;
//新闻来源
@property(nonatomic, copy)      NSString            *source;
//新闻内容摘要
@property(nonatomic, copy)      NSString<Optional>    *summary;
//摘要创建时间
@property(nonatomic, copy)      NSString<Optional>    *summary_create_time;
//摘要更新时间
@property(nonatomic, copy)      NSString<Optional>    *summary_update_time;
//可选项，缩略图地址
@property(nonatomic, copy)      NSArray<NSString *>    *thumbnail_img;
//新闻标题
@property(nonatomic, copy)      NSString            *title;
//分发平台提供的链接
@property(nonatomic, copy)      NSString            *url;

@end
