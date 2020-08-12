//
//  HGCollectionViewCell.m
//  HGSWB
//
//  Created by 黄刚 on 2018/8/1.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGCollectionViewCell.h"

@implementation HGCollectionViewCell

- (UIImageView *)topImage {
    if (!_topImage) {
        _topImage = [UIImageView new];
        _topImage.backgroundColor = [UIColor redColor];
    }
    return _topImage;
}

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor blueColor];
        _label.font = [UIFont systemFontOfSize:15];
        _label.backgroundColor = [UIColor purpleColor];
    }
    return  _label;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutViews];
    }
    
    return self;
}

-(void) layoutViews{
    self.topImage.frame = CGRectMake(10, 0, 70, 70);
    self.label.frame = CGRectMake(10, 80, 70, 30);
    
    [self.contentView addSubview:self.topImage];
    [self.contentView addSubview:self.label];
}

@end
