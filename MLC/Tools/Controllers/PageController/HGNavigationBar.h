//
//  HGNavigationBar.h
//  HGSWB
//
//  Created by 黄刚 on 2019/1/14.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HGNavigationBarAction) {
    HGNavigationBarActionSend           =   0,
    HGNavigationBarActionMine,
};

NS_ASSUME_NONNULL_BEGIN

@interface HGNavigationBar : UIView

@property(nonatomic, strong) RACSubject *searchSubjuct;
@property(nonatomic, copy)  void(^navigationBarCallBack)(HGNavigationBarAction action);

+ (instancetype) navigationBar;

@end

NS_ASSUME_NONNULL_END
