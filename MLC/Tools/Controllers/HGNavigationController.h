//
//  HGNavigationController.h
//  HGSWB
//
//  Created by 黄刚 on 2018/8/3.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGNavigationController : UINavigationController

@property (nonatomic , strong)UIImage *defaultImage;
- (void)startPopGestureRecognizer;
- (void)stopPopGestureRecognizer;

@end
