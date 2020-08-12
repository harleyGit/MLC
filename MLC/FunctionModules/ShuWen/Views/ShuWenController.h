//
//  ViewController.h
//  HGSWB
//
//  Created by 黄刚 on 2018/7/7.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ScrollLabelType) {
    ScrollLabelTypeView,
    ScrollLabelTypeController,
};

@interface ShuWenController : HGPageController

@property(nonatomic, assign) ScrollLabelType scrollType;
@property(nonatomic, strong, readwrite) UIViewController *currentViewController;

@end

