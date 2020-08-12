//
//  HGHomeNewsCell.m
//  HGSWB
//
//  Created by 黄刚 on 2019/2/17.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGHomeNewsCell.h"

static CGFloat itemSpace = 5;
@interface HGHomeNewsCell()

@property(nonatomic, retain)UILabel *titleLabel;
@property (retain, nonatomic) UIImageView *leftImageView;
@property (retain, nonatomic) UIImageView *middleImageView;
@property (retain, nonatomic) UIImageView *rightImageView;
@property (retain, nonatomic) UILabel *infoLabel;
@property(retain, nonatomic) NSArray *imageViews;

@end

@implementation HGHomeNewsCell
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
    }
    return _leftImageView;
}

- (UIImageView *)middleImageView {
    if (!_middleImageView) {
        _middleImageView = [UIImageView new];
    }
    return _middleImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
    }
    return _rightImageView;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [UILabel new];
        _infoLabel.font = [UIFont systemFontOfSize:10];
    }
    return _infoLabel;
}

- (NSArray *)imageViews {
    if (!_imageViews) {
        _imageViews = @[self.leftImageView, self.middleImageView, self.rightImageView];
    }
    return _imageViews;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setModel:(HGHomeNewsSummaryModel *)model {
    _model = model;
    self.titleLabel.text = model.infoModel.title;
    if (model.infoModel.image_list.count == 3) {
        self.leftImageView.hidden = NO;
        self.rightImageView.hidden = NO;
        self.middleImageView.hidden = NO;
        NSArray *imageModels = model.infoModel.image_list;
        [imageModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HGHomeNewsImageModel *imageModel = (HGHomeNewsImageModel *)obj;
            UIImageView *imageView = self.imageViews[idx];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.url]];
        }];
    }else {
        self.leftImageView.hidden = YES;
        self.rightImageView.hidden = YES;
        self.middleImageView.hidden = YES;
    }
    
    self.infoLabel.text = [NSString stringWithFormat:@"%@   %d阅读    0分钟前", model.infoModel.media_name, model.infoModel.read_count];
}

- (void)layoutSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.contentView addSubview:self.leftImageView];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.width.and.height.equalTo(@20);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
