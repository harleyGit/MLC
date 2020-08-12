//
//  HGBaseController.m
//  HGSWB
//
//  Created by 黄刚 on 2019/1/7.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGBaseController.h"

@interface HGBaseController ()

@end

@implementation HGBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubViews];
    //禁用掉自动设置的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self layoutSubViews];
}


#pragma mark -- 导航栏相关
- (UIBarButtonItem *) createItemWithImage:(NSString *)imageName selector:(SEL)selector{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = CGRectMake(0, 0, 21, 21);
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    [imageView addGestureRecognizer:tap];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    
    return item;
}

- (UIBarButtonItem *)createItemWithText:(NSString *)text selector:(SEL)selector {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:self action:selector];
    return item;
}

-(void)addLeftItemWithImageName:(NSString *)imageName {
    self.navigationItem.leftBarButtonItem = [self createItemWithImage:imageName selector:@selector(leftItemAction)];
}

- (void)addRightItemWithImageName:(NSString *)imageName {
    self.navigationItem.rightBarButtonItem = [self createItemWithImage:imageName selector:@selector(rightItemAction)];
}

- (void)addLeftItemWithText:(NSString *)text {
    self.navigationItem.leftBarButtonItem = [self createItemWithText:text selector:@selector(leftItemAction)];
}

- (void)addRightItemWithText:(NSString *)text {
    self.navigationItem.rightBarButtonItem = [self createItemWithText:text selector:@selector(rightItemAction)];
}

- (void)leftItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemAction {}

- (HGNavigationBar *)showCustomNavBar {
    self.navigationController.navigationBar.hidden = YES;
    HGNavigationBar *bar = [HGNavigationBar navigationBar];
    [self.view addSubview:bar];
    
    return bar;
}

- (void) addSubViews {}

- (void) layoutSubViews {}


@end
