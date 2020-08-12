//
//  HGNewsCell.m
//  HGSWB
//
//  Created by 黄刚 on 2018/8/21.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGNewsCell.h"

@interface HGNewsCell()
{
    CGFloat imgSizeWidth;
    CGFloat imgSizeHeight;
}

//新闻标题
@property(nonatomic, retain) UILabel *title;
//来源
@property(nonatomic, retain) UILabel *source;
//发布时间
@property(nonatomic, retain) UILabel *gmt_publish;
//热门指数
@property(nonatomic, retain) UILabel *hot_index;
//缩略图
@property(nonatomic, retain) UIImageView *thumbnail_img;

@end

@implementation HGNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
    }
    return  self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@30);
        
    }];
    
    [self.contentView addSubview:self.thumbnail_img];
    [self.thumbnail_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(5);
        make.left.equalTo(self.title);
        make.width.equalTo(@(self->imgSizeWidth));
        make.height.equalTo(@(self->imgSizeHeight));
    }];
    
    UILabel *source = [HGNewsCell customLabelWithText:@"来源:" textColor:COLOR(255, 79, 89)];
    [self.contentView addSubview:source];
    [source mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.bottom.equalTo(self.contentView);
    }];
    
    
    [self.contentView addSubview:self.source];
    [self.source mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(source.mas_right).offset(2);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.gmt_publish];
    [self.gmt_publish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.source.mas_right).offset(5);
        make.bottom.equalTo(self.source);
    }];
    
    UILabel *heat = [HGNewsCell customLabelWithText:@"热度:" textColor:COLOR(255, 79, 89)];
    [self.contentView addSubview:heat];
    [heat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gmt_publish.mas_right).offset(5);
        make.bottom.equalTo(self.gmt_publish);
    }];
    [self.contentView addSubview:self.hot_index];
    [self.hot_index mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(heat.mas_right).offset(2);
        make.bottom.equalTo(heat);
    }];
}

- (void)bindModel:(HGEachNewsModel *)eachNewsM {
    
    self.title.text       = eachNewsM.title;
    self.source.text      = eachNewsM.source;
    self.gmt_publish.text = [HGTools changeTimeFormatForTiemstamp:eachNewsM.gmt_publish];
    self.hot_index.text   = eachNewsM.hot_index;
    
    if (eachNewsM.thumbnail_img.firstObject != nil) {
//        CGSize originalImgSize = [HGTools pngImageSizeWithURL:eachNewsM.thumbnail_img.firstObject];
//        NSLog(@"--->>imgSize:%@", NSStringFromCGSize(originalImgSize));
    
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:eachNewsM.thumbnail_img.firstObject] options:NSDataReadingUncached error:nil];
        UIImage *newsImg = [UIImage imageWithData:imgData];
        
        CGSize nowSize = [HGTools scaleImage:newsImg toSize:CGSizeMake(160, 80)];
        imgSizeWidth  = nowSize.width;
        imgSizeHeight = nowSize.height;
        
        self.thumbnail_img.image = newsImg;
    }
    
}



- (UILabel *)title {
    if (!_title) {
        _title = [UILabel new];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.numberOfLines = 0;
    }
    return _title;
}

- (UILabel *)source {
    if (!_source) {
        _source = [UILabel new];
        _source.textAlignment = NSTextAlignmentLeft;
        [_source setFont:[UIFont systemFontOfSize:12.0f]];
        _source.textColor = COLOR(208, 208, 208);
    }
    return _source;
}

- (UILabel *)gmt_publish {
    if (!_gmt_publish) {
        _gmt_publish = [UILabel new];
        _gmt_publish.textAlignment = NSTextAlignmentLeft;
        [_gmt_publish setFont:[UIFont systemFontOfSize:12.0f]];
        _gmt_publish.textColor = COLOR(208, 208, 208);
    }
    return  _gmt_publish;
}

- (UILabel *)hot_index {
    if (!_hot_index) {
        _hot_index = [UILabel new];
        _hot_index.textAlignment = NSTextAlignmentCenter;
        [_hot_index setFont:[UIFont systemFontOfSize:12.0f]];
        _hot_index.textColor = COLOR(208, 208, 208);
    }
    return _hot_index;
}

- (UIImageView *)thumbnail_img {
    if (!_thumbnail_img) {
        _thumbnail_img = [UIImageView new];
    }
    return _thumbnail_img;
}

+ (UILabel *) customLabelWithText:(NSString *)text textColor:(UIColor *)textColor{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    label.textColor = textColor;
    [label setFont:[UIFont systemFontOfSize:12.0f]];
    return label;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
