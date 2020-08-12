//
//  HGScrollView.m
//  HGSWB
//
//  Created by 黄刚 on 2019/1/7.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGScrollView.h"


/**
 这里做了默认的一些手势控制，无法做到顾全所有的手势
 若出现手势冲突或者不响应，需要自行对视图的 GestureRecognizerDelegate 进行实现
 */
@implementation HGScrollView

#pragma mark -- UIGestureRecognizerDelegate
//是否允许同时支持多个手势，默认是不支持多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //iOS横向滚动的scrollView和系统pop手势返回冲突的解决办法:http://blog.csdn.net/hjaycee/article/details/49279951
    //兼容系统pop手势 / FDFullscreenPopGesture / 如有自定义手势，需自行对 Gesture 做判断
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
            return YES;
        }
    }
    
    //ReSideMenu 及其他一些手势的开启，需要在这自行定义，目前只有这些。目前还没完全兼容好，会引起一个小问题
    if (self.otherGestuteRecognizerSimultaneously) {
        //判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
            return  YES;
        }
    }
    
    return NO;
}


//这个方法返回YES，第一个手势和第二个互斥时，第一个会失效:https://www.jianshu.com/p/015f851761e0
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //MARK: UITableViewCell 自定义手势需要自行定义
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UITableViewWrapperView")] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

/*
- (void)drawRect:(CGRect)rect {
}
*/

@end
