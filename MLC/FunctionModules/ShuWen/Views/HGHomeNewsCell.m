//
//  HGHomeNewsCell.m
//  HGSWB
//
//  Created by 黄刚 on 2019/2/17.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGHomeNewsCell.h"

//图片之间的间隙距离
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
        [self addCellChildView];
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


- (void) addCellChildView {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.middleImageView];
    [self.contentView addSubview:self.rightImageView];
    [self.contentView addSubview:self.infoLabel];

    [self layoutCellChildView];
}

- (void) layoutCellChildView {
    CGFloat width = (HGSCREEN_WIDTH - 2 * (HGSizeManager.marginLeft + itemSpace)) / 3.0;
    CGFloat imgH = 0.68 * width;

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(20);
        make.left.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(HGSizeManager.marginLeft);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
        make.width.equalTo(@(width));
        make.height.equalTo(@(imgH));
    }];
    [self.middleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(itemSpace);
        make.top.bottom.equalTo(self.leftImageView);
        make.width.equalTo(@(width));
        make.height.equalTo(@(imgH));
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleImageView.mas_right).offset(itemSpace);
        make.top.bottom.equalTo(self.leftImageView);
        make.width.equalTo(@(width));
        make.height.equalTo(@(imgH));
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(20);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.leftImageView.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
