//
//  HGHomeJokeInfoModel.h
//  HGSWB
//
//  Created by 黄刚 on 2019/2/8.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHomeJokeInfoModel : NSObject

@property(nonatomic, copy)NSString *content;
@property(nonatomic, assign)int comment_count;
@property(nonatomic, assign)int star_count;
@property(nonatomic, assign)int hate_count;

@end


@interface HGHomeJokeModel : NSObject

@property(nonatomic, strong)NSArray *data;
@property(nonatomic, copy)NSString *message;

@end

@interface HGHomeJokeSummaryModel : NSObject

@property(nonatomic, copy)NSString *content;
@property(nonatomic, assign)int code;
@property(nonatomic, strong)HGHomeJokeInfoModel *infoModel;

//忽略的属性
@property(nonatomic, assign)BOOL starBtnSelected;
@property(nonatomic, assign)BOOL hateBtnSelected;
@property(nonatomic, assign)BOOL collectionSelected;

@end

NS_ASSUME_NONNULL_END
