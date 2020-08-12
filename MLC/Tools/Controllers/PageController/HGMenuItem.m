//
//  HGMenuItem.m
//  HGSWB
//
//  Created by 黄刚 on 2019/1/3.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGMenuItem.h"

@implementation HGMenuItem{
    CGFloat _normalRed, _normalGreen, _normalBlue, _normalAlpha;
    CGFloat _selectedRed, _selectedGreen, _selectedBlue, _selectedAlpha;
    int _sign;
    CGFloat _gap;
    CGFloat _step;
    __weak CADisplayLink *_link;
}

#pragma mark -- Get
- (CGFloat)speedFactor {
    if (_speedFactor <= 0) {
        _speedFactor = 15.0f;
    }
    return _speedFactor;
}

#pragma mark -- Set
- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [normalColor getRed:&_normalRed green:&_normalGreen blue:&_normalBlue alpha:&_normalAlpha];
}

- (void)setSelecetedColor:(UIColor *)selecetedColor {
    _selecetedColor = selecetedColor;
    [selecetedColor getRed:&_selectedRed green:&_selectedGreen blue:&_selectedBlue alpha:&_selectedAlpha];
}

- (void)setRate:(CGFloat)rate {
    if (rate < 0.0 || rate > 1.0) {
        return;
    }
    
    _rate = rate;
    CGFloat r = _normalRed + (_selectedRed - _normalRed) * rate;
    CGFloat g = _normalGreen + (_selectedGreen - _normalGreen) * rate;
    CGFloat b = _normalBlue + (_selectedBlue - _normalBlue) * rate;
    CGFloat a = _normalAlpha + (_selectedAlpha - _normalAlpha) * rate;
    
    self.textColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
    CGFloat minScale = self.normalSize / self.selectedSize;
    CGFloat trureScale = minScale + (1 - minScale) *rate;
    self.transform = CGAffineTransformMakeScale(trureScale, trureScale);    //https://www.jianshu.com/p/0ee900339103,对这个View进行缩放
}

#pragma mark -- Method

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.normalColor = [UIColor blackColor];
        self.selecetedColor = [UIColor blackColor];
        self.normalSize = 15.0f;
        self.selectedSize = 18.0f;
        self.numberOfLines = 0;
        [self setupGestureRecognizer];
    }
    return self;
}

//点击手势
- (void) setupGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpInside:)];
    [self addGestureRecognizer:tap];
}

//代理执行点击后的Action
- (void) touchUpInside:(id)sender{
    if ([self.delegate respondsToSelector:@selector(didPressedMenuItem:)]) {
        [self.delegate didPressedMenuItem:self];
    }
}

- (void)setSelected:(BOOL)selected withAnimation:(BOOL)animation {
    _selected = selected;
    if (!animation) {
        self.rate = selected ? 1.0 : 0.0;
        return;
    }
    
    _sign = (selected == YES) ? 1 : -1;
    _gap = (selected == YES) ? (1.0 - self.rate) : (self.rate - 0.0);
    _step = _gap / self.speedFactor;
    
    if (_link) {
        [_link invalidate];
    }
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rateChange)];   //https://www.jianshu.com/p/0eeb21244caa,是一个能让我们以和屏幕刷新率相同的频率将内容画到屏幕上的定时器
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _link = link;
}

- (void)rateChange {
    if (_gap > 0.000001) {
        _gap -= _step;
        if (_gap < 0.0) {
            self.rate = (int)(self.rate + _sign * _step + 0.5);
            return;
        }
        self.rate += _sign * _step;
    }else {
        self.rate = (int)(self.rate + 0.5);
        [_link invalidate];
        _link = nil;
    }
}

@end
