//
//  HGVideoCell.m
//  HGSWB
//
//  Created by 黄刚 on 2019/2/9.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGVideoCell.h"

@interface HGVideoCell()

@property (retain, nonatomic)UILabel *titleLabel;
@property (retain, nonatomic)UIImageView *iconImageView;
@property (retain, nonatomic)UILabel *authorLabel;
@property (retain, nonatomic)UIButton *playBtn;
@property (retain, nonatomic)UILabel *timeLabel;
@property (retain, nonatomic)UIImageView *videoPosterImageView;

@end

@implementation HGVideoCell

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}

-(UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [UILabel new];
    }
    return _authorLabel;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton new];
    }
    
    return _playBtn;
}

- (UILabel *)timeLabel {
    if (!_titleLabel) {
        _timeLabel = [UILabel new];
    }
    return _timeLabel;
}

- (UIImageView *)videoPosterImageView {
    if (!_videoPosterImageView) {
        _videoPosterImageView = [UIImageView new];
    }
    return _videoPosterImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor purpleColor];
        
        //初始化控件
        [self initicialControls];
    }
    return self;
}


- (void) initicialControls {
    self.videoPosterImageView.tag = 9999;
    self.videoPosterImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.videoPosterImageView.clipsToBounds = YES;
    self.videoPosterImageView.userInteractionEnabled = YES;
    self.videoPosterImageView.backgroundColor = [UIColor lightGrayColor];
    
    self.timeLabel.layer.cornerRadius = 9;
    self.timeLabel.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick)];
    [self.videoPosterImageView addGestureRecognizer:tap];
    
    [self.videoPosterImageView addSubview:self.playBtn];
    [self.videoPosterImageView addSubview:self.timeLabel];
    [self.videoPosterImageView addSubview:self.titleLabel];
    
    
}

- (void)setModel:(HGVideoListModel *)model {
    _model = model;
    
    [_videoPosterImageView sd_setImageWithURL:[NSURL URLWithString:model.videoModel.videoInfoModel.poster_url]];
    _timeLabel.text = model.videoModel.title;
    int second = model.videoModel.videoInfoModel.video_duration;
    _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", second/60, second %60];
    _authorLabel.text = model.videoModel.media_name;
    
    __weak typeof(self) wself = self;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.videoModel.user_info.avatar_url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            //高效切圆角 -> 尽量不去尝试去重写 drawRect
            wself.iconImageView.image = [image hn_drawRectWithRoundedCorner:wself.iconImageView.frame.size.width / 2.0 size:wself.iconImageView.frame.size];
        }
    }];
    
    if (model.playing) {
        self.iconImageView.hidden = YES;
    }else {
        [self refreshCellStatus];
    }
}


- (void)imageViewClick {
    if (_imageViewCallBack) {
        _imageViewCallBack(self.videoPosterImageView);
    }
    self.iconImageView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
