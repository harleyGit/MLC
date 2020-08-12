//
//  HGNavigationController.m
//  HGSWB
//
//  Created by 黄刚 on 2018/8/3.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGNavigationController.h"

@interface HGNavigationController ()<UIGestureRecognizerDelegate>

@property (nonatomic , strong)UIPanGestureRecognizer *pan;


@end

@implementation HGNavigationController

+ (void)initialize {
    [[UINavigationBar appearance] setTranslucent:NO];
    NSMutableDictionary * color = [NSMutableDictionary dictionary];
    color[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    color[NSForegroundColorAttributeName] = [UIColor blackColor];
    [[UINavigationBar appearance] setTitleTextAttributes:color];
    
    // 拿到整个导航控制器的外观
    UIBarButtonItem * item = [UIBarButtonItem appearance];
    NSMutableDictionary * atts = [NSMutableDictionary dictionary];
    atts[NSFontAttributeName] = [UIFont systemFontOfSize:15.0f];
    [item setTitleTextAttributes:atts forState:UIControlStateNormal];
    //    [[UINavigationBar appearance] setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:0.83 green:0.24 blue:0.24 alpha:1]] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _defaultImage = [self.class createImageWithColor:[UIColor colorWithRed:0.83 green:0.24 blue:0.24 alpha:1]];
    [self addCustomGesPop];
    
}

+ (UIImage*)createImageWithColor:(UIColor*)color{
    
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    self.navigationBar.topItem.title = @"";
    [super pushViewController:viewController animated:animated];
}



- (void)addCustomGesPop {
    // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    //去除警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:@selector(handleNavigationTransition:)];
#pragma clang diagnostic pop
    _pan = pan;
    
    pan.delegate = self;
    
    [self.view addGestureRecognizer:pan];
    
    self.interactivePopGestureRecognizer.enabled = NO;
    
}


#pragma mark -- UIGestureRecognizerDelegate
//手指触摸屏幕后回调的方法，返回NO则不再进行手势识别
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class]) isEqual:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
    
}

//判断手势是否应该触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //只有非根控制器才开滑动返回，所以再这里判断一下是否为根控制器
    if (self.childViewControllers.count == 1) {
        return NO;
    }
    return YES;
}


- (void)startPopGestureRecognizer {
    [self.view addGestureRecognizer:self.pan];
}
- (void)stopPopGestureRecognizer {
    [self.view removeGestureRecognizer:self.pan];
}


@end
