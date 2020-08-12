//
//  HGMyTableCell.m
//  HGSWB
//
//  Created by 黄刚 on 2018/9/5.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGMyTableCell.h"

@interface HGMyTableCell()

@property(nonatomic, retain) UIImageView *headPortrait;
@property(nonatomic, retain) UILabel *nickName;
@property(nonatomic, retain) UILabel *fansNum;

@end

@implementation HGMyTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void) bindModel:(id)model {
    if ([model isKindOfClass:[HGMyModel class]]) {
        HGMyModel *mm = model;
        self.headPortrait.image = [UIImage imageWithData:[NSString switchToDataForURLString:mm.profile_image_url]];
        self.nickName.text = mm.name;
        self.fansNum.text = [NSString stringWithFormat:@"%@ 粉丝", mm.followers_count];
        self.cellKind = MyCellKindPersonalWeiBo;
    }else {
        self.headPortrait.image = [UIImage imageNamed:model[0]];
        self.nickName.text = model[1];
        if ([model[1] isEqualToString:@" "]) {
            self.cellKind = MyCellKindPersonalWeiBo;
        }else {
            self.cellKind = MyCellKindSetting;
        }
    }
}

+ (CGFloat) heightWithModel:(id)model {
    HGMyTableCell *cell = [[HGMyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [cell bindModel:model];
    [cell layoutIfNeeded];
    CGRect frame = cell.headPortrait.frame;
    CGFloat height =  frame.origin.y + frame.size.height + 15;

    return height;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView addSubview:self.headPortrait];
    [self.contentView addSubview:self.nickName];
    
    if (self.cellKind == MyCellKindPersonalWeiBo) {
        [self.contentView addSubview:self.fansNum];
        
        [self.headPortrait mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@60);
            make.left.equalTo(@15);
            make.top.equalTo(@15);
        }];
        [self.nickName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headPortrait.mas_right).offset(15);
            make.top.equalTo(self.headPortrait);
        }];
        [self.fansNum mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nickName.mas_bottom).offset(15);
            make.left.equalTo(self.nickName);
        }];
    }else {
        [self.headPortrait mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@20);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(15);
        }];
        [self.nickName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headPortrait);
            make.left.equalTo(self.headPortrait.mas_right).offset(20);
        }];
    }
}


#pragma mark -- LAZY
- (UIImageView *)headPortrait {
    if (!_headPortrait) {
        _headPortrait = [UIImageView new];
    }
    return _headPortrait;
}

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [UILabel new];
        _nickName.font = [UIFont systemFontOfSize:18.0];
        _nickName.numberOfLines = 1;
    }
    return _nickName;
}

- (UILabel *)fansNum {
    if (!_fansNum) {
        _fansNum = [UILabel new];
        _fansNum.font = [UIFont systemFontOfSize:12.0];
        _fansNum.numberOfLines = 1;
    }
    return _fansNum;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
