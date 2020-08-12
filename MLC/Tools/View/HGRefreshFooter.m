//
//  HGRefreshFooter.m
//  HGSWB
//
//  Created by 黄刚 on 2019/2/8.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGRefreshFooter.h"

@interface HGRefreshFooter()

@property(nonatomic, weak) UILabel *label;
@property(nonatomic, weak) UIImageView *imageViewLoading;

@end

@implementation HGRefreshFooter

#pragma mark -- 重写方法
#pragma mark -- 初始化配置

- (void)prepare {
    [super prepare];
    
    //设置控件高度
    self.mj_h = 50.0f;
    
    //添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_add_video_16x16_"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:logo];
    self.imageViewLoading = logo;
    self.automaticallyHidden = YES;
    
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    
    self.label.frame = self.bounds;
    self.imageViewLoading.bounds = CGRectMake(0, 0, 16, 16);
    self.imageViewLoading.center = CGPointMake(self.mj_w * 0.5 + 60, self.mj_h * 0.5);
}

#pragma mark -- 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"上拉加载数据";
            self.imageViewLoading.hidden = NO;
            [self.imageViewLoading stopRotationAnimation];
            break;
            
        case MJRefreshStateRefreshing:
            self.label.text = @"正在努力加载";
            self.imageViewLoading.hidden = NO;
            [self.imageViewLoading rotationAnimation];
            break;
            
        case MJRefreshStateNoMoreData:
            self.label.text = @"没有数据了";
            self.imageViewLoading.hidden = YES;
            [self.imageViewLoading stopRotationAnimation];
            break;
            
        default:
            break;
    }
}

@end
