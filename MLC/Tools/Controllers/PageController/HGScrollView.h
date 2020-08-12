//
//  HGScrollView.h
//  HGSWB
//
//  Created by 黄刚 on 2019/1/7.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGScrollView : UIScrollView<UIGestureRecognizerDelegate>

//左滑时同时启用其他手势，比如系统左滑、sidemenu左滑。默认 NO
@property(nonatomic, assign) BOOL otherGestuteRecognizerSimultaneously;

@end

NS_ASSUME_NONNULL_END
