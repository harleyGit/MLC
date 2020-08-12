//
//  HGBaseController.h
//  HGSWB
//
//  Created by 黄刚 on 2019/1/7.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HGBaseControllerRefreshProtocol <NSObject>

@optional
- (void)needRefreshTableViewData;

- (void)rightItemAction;

@end


@class HGNavigationBar;
@interface HGBaseController : UIViewController<HGBaseControllerRefreshProtocol>

- (void) addLeftItemWithImageName:(NSString *)imageName;

- (void) addRightItemWithImageName:(NSString *)imageName;

- (void) addLeftItemWithText:(NSString *)text;

- (void) addRightItemWithText:(NSString *)text;

- (void) leftItemAction;

- (HGNavigationBar *) showCustomNavBar;

- (void) addSubViews;

- (void) layoutSubViews;

@end

NS_ASSUME_NONNULL_END
