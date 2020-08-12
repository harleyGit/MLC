//
//  HGHomeJokeCell.m
//  HGSWB
//
//  Created by 黄刚 on 2019/2/16.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGHomeJokeCell.h"
@interface HGHomeJokeCell()

@property(nonatomic, strong)UILabel *contentLabel;
@property(nonatomic, strong)UIButton *likeBtn;
@property(nonatomic, strong)UIButton *hateBtn;
@property(nonatomic, strong)UIButton *collectionBtn;
@property(nonatomic, strong)UIView *lineView;
@property(nonatomic, strong)UIButton *commentBtn;
@property(nonatomic, retain)UILabel *plusLabel;

@end

@implementation HGHomeJokeCell

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
    }
    return _contentLabel;
}

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton new];
        [_likeBtn addTarget:self action:@selector(likeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeBtn;
}

- (UIButton *)hateBtn {
    if (!_hateBtn) {
        _hateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hateBtn addTarget:self action:@selector(hateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hateBtn;
}

- (UIButton *)collectionBtn {
    if (!_collectionBtn) {
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = HN_MIAN_GRAY_Color;
    }
    return _lineView;
}

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _commentBtn;
}

- (UILabel *)plusLabel {
    if (!_plusLabel) {
        _plusLabel = [UILabel new];
        _plusLabel.text = @"+1";
        // 今日头条这里并没有采用系统的字体
        _plusLabel.textAlignment = NSTextAlignmentCenter;
        _plusLabel.font = [UIFont systemFontOfSize:18];
        _plusLabel.frame = CGRectMake(0, 0, 20,20);
        _plusLabel.textColor = HN_MIAN_STYLE_COLOR;
        _plusLabel.transform = CGAffineTransformMakeScale(0.4, 0.4);
        _plusLabel.hidden = YES;
    }
    return _plusLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setModel:(HGHomeJokeSummaryModel *)model {
    _model = model;
    self.contentLabel.text = model.infoModel.content;
    self.likeBtn.selected = model.starBtnSelected;
    self.hateBtn.selected = model.hateBtnSelected;
    self.collectionBtn.selected = model.collectionSelected;
    
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%d", model.infoModel.star_count] forState:UIControlStateNormal];
    [self.hateBtn setTitle:[NSString stringWithFormat:@"%d", model.infoModel.hate_count] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%d", model.infoModel.comment_count] forState:UIControlStateNormal];
}


- (void)layoutSubviews {
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@30);
    }];
}

#pragma mark -- Action
- (void)likeBtnClickAction:(UIButton *)sender {
    if ([self showLogMsg]) {
        return;
    }
    
    sender.selected = !sender.selected;
    self.model.infoModel.star_count += 1;
    self.model.starBtnSelected = sender.selected;
    
    [self addAnimationForSender:sender];
}

- (void) hateBtnClick:(UIButton *)sender {
    if ([self showLogMsg]) {
        return;
    }
    
    self.model.infoModel.hate_count += 1;
    sender.selected = !sender.selected;
    self.model.hateBtnSelected = sender.selected;
    [self addAnimationForSender:sender];
    
}

- (void)collectionBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.model.collectionSelected = sender.selected;
    [self addAnimationForSender:sender];
}


- (BOOL)showLogMsg {
    if (self.hateBtn.selected) {
        [HGProgressHUD showError:@"您已经踩过了！"];
        return YES;
    }
    
    if (self.likeBtn.selected){
        [HGProgressHUD showError:@"您已经赞过了!"];
        return YES;
    }
    
    return NO;
}

-(void)addAnimationForSender:(UIButton *)sender {
    if ([sender.layer animationForKey:@"show"]) {
        [sender.layer removeAnimationForKey:@"show"];
    }
    
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.5), @(1.2), @(1)];
    k.keyTimes = @[@(0.0), @(0.5), @(0.8), @(1.0)];
    k.calculationMode = kCAAnimationLinear;
    k.duration = 0.25;
    [sender.layer addAnimation:k forKey:@"show"];
    if (sender != self.likeBtn && sender != self.hateBtn) {
        return;
    }
    
    if (sender == self.likeBtn) {
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%d", self.model.infoModel.star_count] forState:UIControlStateNormal];
    }
    
    if (sender == self.hateBtn) {
        [self.hateBtn setTitle:[NSString stringWithFormat:@"%d", self.model.infoModel.hate_count] forState:UIControlStateNormal];
    }
    
    self.plusLabel.hidden = NO;
    self.plusLabel.center = CGPointMake(sender.center.x -10, sender.center.y -15);
    [UIView animateWithDuration:0.25 animations:^{
        self.plusLabel.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        self.plusLabel.hidden = YES;
        self.plusLabel.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
