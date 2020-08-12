//
//  HGRootController.m
//  HGSWB
//
//  Created by 黄刚 on 2018/8/3.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGRootController.h"

@interface HGRootController ()

@end

@implementation HGRootController

+ (void)initialize {
    
    [[UITabBar appearance] setTranslucent:NO];
    [UITabBar appearance].barTintColor = HN_MIAN_GRAY_Color;
    
    UITabBarItem *item = [UITabBarItem appearance];
    
    item.titlePositionAdjustment = UIOffsetMake(0, -5);
    
    NSMutableDictionary *normalAtts = [NSMutableDictionary dictionary];
    normalAtts[NSFontAttributeName] = [UIFont systemFontOfSize:10.0f];
    normalAtts[NSForegroundColorAttributeName] = HGDEFAULT_COLOR;
    [item setTitleTextAttributes:normalAtts forState:UIControlStateNormal];
    
    NSMutableDictionary *selectAtts = [NSMutableDictionary dictionary];
    selectAtts[NSFontAttributeName] = [UIFont systemFontOfSize:10.0f];
    selectAtts[NSForegroundColorAttributeName] = HGMAIN_COLOR;
    [item setTitleTextAttributes:selectAtts forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HGDEFAULT_COLOR;
    self.tabBar.translucent = FALSE;    //半透明设置
    
    [self addViewControllers];
    
    [HGRootController getAppBuildVersion];
}

+ (void) getAppBuildVersion {
    NSBundle *currentBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [currentBundle infoDictionary];
    
    NSString *buildVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"版本号：%@", buildVersion);
    
    NSString *packageInfo = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    NSLog(@"App包名信息：%@", packageInfo);
    
    NSString *appNameInfo = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"App名称信息：%@", appNameInfo);
    
    NSString *device = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSLog(@"App设备ID: %@", device);

}

- (void) addViewControllers {
    ShuWenController *swc = [[ShuWenController alloc] init];
    //滚动类型判断
    swc.scrollType = ScrollLabelTypeController;
    [HGRootController setBarItem:swc.tabBarItem itemTitle:@"数闻" titleSize:14.0f selectedTitleColor:HGMAIN_COLOR unselectedTitleColor:HGNOT_SELECT_COLOR unselectedImage:@"tab_unselected_news" selectedImage:@"tab_selected_news"];
    
    HGWeiBoController *wbc = [HGWeiBoController new];
    [HGRootController setBarItem:wbc.tabBarItem itemTitle:@"微博" titleSize:14.0f selectedTitleColor:HGMAIN_COLOR unselectedTitleColor:HGNOT_SELECT_COLOR unselectedImage:@"tab_unselected_weibo" selectedImage:@"tab_selected_weibo"];
    
    HGVideoController *vc = [HGVideoController new];
    [HGRootController setBarItem:vc.tabBarItem itemTitle:@"视频" titleSize:14.0f selectedTitleColor:HGMAIN_COLOR unselectedTitleColor:HGNOT_SELECT_COLOR unselectedImage:@"tab_unselected_video" selectedImage:@"tab_selected_video"];
    
    HGNavigationController *mc = [[HGNavigationController alloc] initWithRootViewController:[HGMyController new]];
    [HGRootController setBarItem:mc.tabBarItem itemTitle:@"我" titleSize:14.0f selectedTitleColor:HGMAIN_COLOR unselectedTitleColor:HGNOT_SELECT_COLOR unselectedImage:@"tab_my_nor" selectedImage:@"tab_my_selected"];
    
    [self addChildViewController:swc];
    [self addChildViewController:wbc];
    [self addChildViewController:vc];
    [self addChildViewController:mc];
    
}




+ (void) setBarItem:(UITabBarItem *)tabBarItem  itemTitle:(NSString *)title titleSize:(CGFloat)size selectedTitleColor:(UIColor *)selectTitleColor unselectedTitleColor:(UIColor *)unTitleColor unselectedImage:(NSString *)unselectImage selectedImage:(NSString *)selectImage {
    
    
    //设置图片
    tabBarItem = [tabBarItem initWithTitle:title image:[[UIImage imageNamed:unselectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 6, 0);
    
    //未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: unTitleColor} forState:UIControlStateNormal];

    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: selectTitleColor} forState:UIControlStateSelected];
    //controller.tabBarItem.badgeValue = @"12"; //提示数字
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
