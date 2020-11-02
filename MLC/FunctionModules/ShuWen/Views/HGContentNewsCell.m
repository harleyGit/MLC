//
//  HGContentNewsCell.m
//  HGSWB
//
//  Created by 黄刚 on 2019/2/18.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGContentNewsCell.h"

static CGFloat itemSpace = 5;
@interface HGContentNewsCell()

@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UIImageView *contentImageView;
@property (retain, nonatomic) UIButton *deleBtn;
@property (retain, nonatomic) UILabel *deitialLabel;

@end

@implementation HGContentNewsCell

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [UIImageView new];
    }
    return _contentImageView;
}

- (UIButton *)deleBtn {
    if (!_deleBtn) {
        _deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _deleBtn;
}

- (UILabel *)deitialLabel {
    if (!_deitialLabel) {
        _deitialLabel = [UILabel new];
        _deitialLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _deitialLabel;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addCellChildView];
    }
    
    return self;
}

- (void)setModel:(HGHomeNewsSummaryModel *)model {
    _model = model;
    _titleLabel.text = model.infoModel.title;
    if (model.infoModel.middle_image) {
        _contentImageView.hidden = NO;
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:model.infoModel.middle_image.url]];
        //约束设置未写
    }else {
        //约束设置未写
        _contentImageView.hidden = YES;
    }
    
    _deitialLabel.text = [NSString stringWithFormat:@"%@   %d阅读  0分钟前",model.infoModel.media_name,model.infoModel.read_count];
}

- (void) addCellChildView {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.deitialLabel];

    [self layoutCellChildView];
    
}

- (void) layoutCellChildView {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(HGSizeManager.marginLeft);
        make.height.greaterThanOrEqualTo(@40);
        make.right.equalTo(self.contentView).offset(-HGSizeManager.marginRight);
    }];
    
    [self.deitialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.height.equalTo(@12);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
        make.right.equalTo(self.contentView).offset(-HGSizeManager.marginRight);
        make.bottom.equalTo(self.contentView).offset(-HGSizeManager.marginBottom);
    }];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
