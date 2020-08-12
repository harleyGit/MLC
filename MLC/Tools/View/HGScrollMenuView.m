//
//  HGScrollView.m
//  HGSWB
//
//  Created by 黄刚 on 2018/7/15.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
////资料：https://blog.csdn.net/zhanglizhi111/article/details/52794883


#import "HGScrollMenuView.h"
#define HGNAV_TAB_BAR_HEIGHT        64

@interface HGScrollMenuView()<UIScrollViewDelegate>
{
    CGFloat             viewWidth;   //视图的宽和高
    CGFloat             viewHeight;
    NSInteger           currentPage; //当前页面
}
@property(nonatomic, copy)   NSArray        *titles;
@property(nonatomic, retain) NSArray        *views;
@property(nonatomic, retain) UIScrollView   *scrollMainView;
@property(nonatomic, retain) UIScrollView   *segmentTitleView;
@property(nonatomic, retain) NSMutableArray *items;                         //存放title的button
@end

@implementation HGScrollMenuView

#pragma mark - LAZY
- (UIScrollView *)scrollMainView {
    if (!_scrollMainView) {
        CGRect frame = CGRectMake(0, self.menuBarHeight, viewWidth, viewHeight - self.menuBarHeight);
        _scrollMainView = [[UIScrollView alloc] initWithFrame: frame];
        _scrollMainView.pagingEnabled = YES;
        _scrollMainView.contentSize = CGSizeMake(viewWidth * self.views.count, viewHeight - self.menuBarHeight);
        _scrollMainView.showsVerticalScrollIndicator = FALSE;
        _scrollMainView.showsHorizontalScrollIndicator = FALSE;
        _scrollMainView.delegate = self;
        _scrollMainView.bounces = FALSE;
        _scrollMainView.backgroundColor = [UIColor orangeColor];
    }
    return _scrollMainView;
}

- (UIScrollView *)segmentTitleView {
    if (!_segmentTitleView) {
        CGRect frame = CGRectMake(0, 0, viewWidth, self.menuBarHeight);
        _segmentTitleView = [[UIScrollView alloc] initWithFrame: frame];
        _segmentTitleView.contentSize = CGSizeMake(self.menuBarWidth * self.titles.count, self.menuBarHeight);
        _segmentTitleView.showsHorizontalScrollIndicator = FALSE;
        _segmentTitleView.showsVerticalScrollIndicator = FALSE;
        _segmentTitleView.delegate = self;
        _segmentTitleView.bounces = FALSE;
        _segmentTitleView.backgroundColor = [UIColor redColor];
    }
    return  _segmentTitleView;
}

- (UIImageView *)scrollLine {
    if (!_scrollLine) {
        _scrollLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.menuBarHeight -1, self.menuBarWidth, self.lineHeight)];
        _scrollLine.backgroundColor = [UIColor blackColor];//HGDEFAULT_COLOR;
    }
    return _scrollLine;
}

//导航菜单的高度
- (CGFloat)menuBarHeight {
    if (_menuBarHeight <= 0) {
        _menuBarHeight = 64;
    }
    return _menuBarHeight;
}
//导航菜单的宽度
- (CGFloat)menuBarWidth {
    if (_menuBarWidth <= 0) {
        _menuBarWidth = self.frame.size.width / 4;
    }
    return _menuBarWidth;
}

- (CGFloat)lineHeight {
    if (_lineHeight <= 0) {
        _lineHeight = 1;
    }
    return _lineHeight;
}


- (instancetype)initWithFrame:(CGRect)frame  titles:(NSArray *)titles contentViews:(NSArray *)views {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HGDEFAULT_COLOR;
        
        self.items = [NSMutableArray arrayWithCapacity:1];
        self.views = views;
        self.titles = titles;
        
        viewWidth     = frame.size.width;
        viewHeight    = frame.size.height;
        currentPage   = 0;                  //默认当前页面
        
        [self addSubview:self.segmentTitleView];
        [self addSubview:self.scrollMainView];
        
        [self addItemsToSegmentTitleWithTitles:self.titles];
        [self addViewsToScrollMainView:views];
    }
    return self;
}

- (void) addItemsToSegmentTitleWithTitles:(NSArray *) titles {
    for (NSInteger index = 0; index < titles.count; index ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(index * self.menuBarWidth, 0, self.menuBarWidth, self.menuBarHeight);
        button.titleLabel.font = HGTABBAR_TITLE_FONT;
        button.backgroundColor = [UIColor yellowColor];//HGDEFAULT_COLOR;
        [button setTitle:titles[index] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(segmentItemPressedAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.segmentTitleView addSubview:button];
        [self.items addObject:button];
    }
    [self.segmentTitleView addSubview:self.scrollLine];
}

- (void) addViewsToScrollMainView:(NSArray *) views {
    for (int i = 0; i < views.count;  i ++) {
        UIView *view = views[i];
        view.frame = CGRectMake(i * viewWidth, 0, viewWidth, viewHeight - self.menuBarHeight);
        [self.scrollMainView addSubview: view];
    }
}

- (void) segmentItemPressedAction:(UIButton *)sender {
    NSInteger index = [self.items indexOfObject:sender];
    currentPage     = index;
    
    CGRect changeFrame = CGRectMake(viewWidth * index, self.menuBarHeight, viewWidth, viewHeight - self.menuBarHeight);
    [self.scrollMainView scrollRectToVisible:changeFrame animated:YES];
}

- (void) linkageViewTimelyWithScrollView {
    //获取顶部菜单栏与view的宽度一半的差值
    CGFloat contentOff_x = currentPage  * self.menuBarWidth - viewWidth/2;
    
    [UIView animateWithDuration:0.3f animations:^{
        CGRect lineFrame = self.scrollLine.frame;
        lineFrame.origin = CGPointMake(self->currentPage * self.menuBarWidth, self.menuBarHeight -1);
        self.scrollLine.frame = lineFrame;
    }];
    
    //菜单栏足够宽，不需要滚动判断
    if (contentOff_x < 0) {
        [UIView animateWithDuration:0.3f animations:^{
            self.segmentTitleView.contentOffset = CGPointMake(0, 0);
        }];
    }else if (contentOff_x <= self.segmentTitleView.contentSize.width - viewWidth) {
        //菜单栏不够宽需要滚动，但不能超越原有contentSize值
        [UIView animateWithDuration:0.3f animations:^{
            self.segmentTitleView.contentOffset = CGPointMake(contentOff_x, 0);
        }];
    }
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / viewWidth;
    currentPage = index;
    
    if (scrollView == self.scrollMainView) {
        [self linkageViewTimelyWithScrollView];
    }
}

// 滚动完毕就会调用（如果是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView { }

// 滚动完毕就会调用（如果不是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView { }

@end
