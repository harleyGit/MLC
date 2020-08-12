//
//  HGHomeNewsModel.h
//  HGSWB
//
//  Created by 黄刚 on 2019/2/8.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHomeNewsModel : NSObject

@property(nonatomic, strong)NSArray *data;
@property(nonatomic, copy)NSString *message;
@property(nonatomic, copy)NSString *post_content_hint;
@property(nonatomic, assign)int total_number;

@end

@interface HGHomeNewsImageModel : NSObject

@property (nonatomic , copy)NSString *type;
@property (nonatomic , copy)NSString *width;
@property (nonatomic , copy)NSString *url;
@property (nonatomic , copy)NSString *height;

@end

@interface HGHomeNewsInfoModel : NSObject

@property (nonatomic , copy)NSString *abstract;
@property (nonatomic , copy)NSString *media_name;
@property (nonatomic , assign)int read_count;
@property (nonatomic , strong)NSArray *image_list;
@property (nonatomic , copy)NSString *display_url;
@property (nonatomic , strong)HGHomeNewsImageModel *middle_image;
//资深记者 娱评人
@property (nonatomic , copy)NSString *verified_content;
@property (nonatomic , copy)NSString *title;
@property (nonatomic , copy)NSString *keywords;
@property (nonatomic , assign)int cell_type;

@property (nonatomic , copy)NSString *article_url;

@end

@interface HGHomeNewsSummaryModel : NSObject

@property(nonatomic, copy)NSString *content;
@property(nonatomic, assign)int code;
@property(nonatomic, strong)HGHomeNewsInfoModel *infoModel;

@end

NS_ASSUME_NONNULL_END
