//
//  HGRefreshGifHeader.m
//  HGSWB
//
//  Created by 黄刚 on 2019/1/7.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGRefreshGifHeader.h"
#define HGRefreshStateRefreshingImagesCount 16


@interface HGRefreshGifHeader()

@property(weak, nonatomic) UILabel *label;

@end


@implementation HGRefreshGifHeader

#pragma mark -- 重写方法
#pragma mark -- 初始化配置（比如添加子控件)
- (void) prepare {
    [super prepare];
    
    self.mj_h = 50;
    NSMutableArray *refreshingImages = [NSMutableArray arrayWithCapacity:2];
    for (NSUInteger i = 1; i < HGRefreshStateRefreshingImagesCount; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%lu", i]];
        [refreshingImages addObject:image];
    }
    
    [self setImages:refreshingImages forState:MJRefreshStateIdle];
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    //添加Label
    UILabel *label = [UILabel new];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:10.0f];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    self.label = label;
}


//在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    
    self.label.frame = CGRectMake(0, self.mj_h -15.0f, self.mj_w, 15.0f);
    self.gifView.frame = CGRectMake((self.mj_w -25)/ 2.0, 5, 25, 25);
}

//监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"下拉推荐";
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"推荐中";
            break;
        case MJRefreshStatePulling:
            self.label.text = @"松开推荐";
            break;
            
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
