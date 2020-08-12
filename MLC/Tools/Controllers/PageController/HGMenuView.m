//
//  HGMenuView.m
//  HGSWB
//
//  Created by 黄刚 on 2018/12/30.
//  Copyright © 2018 HuangGang'sMac. All rights reserved.
//

#import "HGMenuView.h"

@interface HGMenuView()<HGMenuItemDelegate>

@property(nonatomic, strong) NSMutableArray *frames;        //每个item的的frame值
@property(nonatomic, readonly) NSInteger titlesCount;

@end
static NSInteger const HGMenuItemTagOffset = 6250;
static NSInteger const HGBadgeViewTagOffset = 1212;

@implementation HGMenuView
#pragma mark -- Set
- (void)setLayoutMode:(HGMenuViewLayoutMode)layoutMode {
    _layoutMode = layoutMode;
    if (!self.superview) {
        return;
    }
    
    [self reload];
}


#pragma mark -- Get
- (NSMutableArray *)frames {
    if (!_frames) {
        _frames = [NSMutableArray array];
    }
    return _frames;
}

- (NSInteger)titlesCount {
    return [self.dataSource numberOfTitlesInMenuView:self];
}

#pragma mark -- Set
- (void)setContentMargin:(CGFloat)contentMargin {
    _contentMargin = contentMargin;
    if (self.scrollView) {
        [self resetFrames];
    }
}

//Menu的frame赋值
- (void)resetFrames {
    CGRect frame = self.bounds; //Menu的frame赋值
    if (self.rightView) {
        CGRect rightFrame = self.rightView.frame;
        rightFrame.origin.x = frame.size.width - rightFrame.size.width;
        self.rightView.frame = rightFrame;
        frame.size.width -= rightFrame.size.width;
    }
    
    if (self.leftView) {
        CGRect leftFrame = self.leftView.frame;
        leftFrame.origin.x = 0;
        self.leftView.frame = leftFrame;
        frame.origin.x += leftFrame.size.width;
        frame.size.width -= leftFrame.size.width;
    }
    
    frame.origin.x += self.contentMargin;
    frame.size.width -= self.contentMargin * 2;
    self.scrollView.frame = frame;
    [self resetFramesFromIndex:0];//重置自身frame的值，计算frame内item的布局
}

- (void)refreshContentOffset {
    CGRect frame = self.selItem.frame;
    CGFloat itemX = frame.origin.x;
    CGFloat width = self.scrollView.frame.size.width;
    CGSize contentSize = self.scrollView.contentSize;
    if (itemX > width/2) {
        CGFloat targetX;
        if ((contentSize.width - itemX) <= width/2) {
            targetX = contentSize.width - width;
        }else {
            targetX = frame.origin.x - width/2 + frame.size.width/2;
        }
        
        //应该有更好的解决方法
        if (targetX + width > contentSize.width) {
            targetX = contentSize.width - width;
        }
        [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    }else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)deselectedItemsIfNeeded {
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[HGMenuItem class]] || obj == self.selItem) {
            return ;
        }
        [(HGMenuItem *)obj setSelected:NO withAnimation:NO];
    }];
}

//内容滑动时，对顶部导航栏的Item进行一定的缩放效果展示
- (void)slideMenuAtProgress:(CGFloat)progress {
    if (self.progressView) {
        self.progressView.progress = progress;
    }
    
    NSInteger tag = (NSInteger)progress + HGMenuItemTagOffset;
    CGFloat rate = progress - tag + HGMenuItemTagOffset;
    HGMenuItem *currentItem = (HGMenuItem *)[self viewWithTag:tag];
    HGMenuItem *nextItem = (HGMenuItem *)[self viewWithTag:tag +1];
    if (rate == 0.0) {
        [self.selItem setSelected:NO withAnimation:NO];
        self.selItem = currentItem;
        [self.selItem setSelected:YES withAnimation:NO];
        [self refreshContenOffset];
        return;
    }
    
    currentItem.rate = 1 -rate; //对Menu的item进行一定的缩放效果展示
    nextItem.rate = rate;
}


- (void)setProgressWidths:(NSArray *)progressWidths {
    _progressWidths = progressWidths;
    
    if (!self.progressView.superview) {
        return;
    }
    
    [self resetFramesFromIndex:0];
}

- (void)setProgressViewIsNaughty:(BOOL)progressViewIsNaughty {
    _progressViewIsNaughty = progressViewIsNaughty;
    if (self.progressView) {
        self.progressView.naughty = progressViewIsNaughty;
    }
}

- (void)setProgressViewCornerRadius:(CGFloat)progressViewCornerRadius {
    _progressViewCornerRadius = progressViewCornerRadius;
    if (self.progressView) {
        self.progressView.cornerRadius = _progressViewCornerRadius;
    }
}

#pragma mark -- Menthod
//系统方法调用
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.scrollView) {
        return;
    }
    
    [self addScrollView];
    [self addItems];
    [self makeStyle];
    [self addBadgeViews];
    
    //insert View
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, [UIScreen mainScreen].bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
    [self addSubview:lineView];
    self.backgroundColor = [UIColor whiteColor];
    
    if (self.selectIndex == 0) {
        return;
    }
    [self selectItemAtIndex:self.selectIndex];
}


//添加角标视图
- (void) addBadgeViews {
    for (int i = 0; i < self.titlesCount; i ++) {
        [self addBadgeViewAtIndex:i];
    }
}

- (void) addBadgeViewAtIndex:(NSInteger)index {
    UIView *badgeView = [self badgeViewAtIndex:index];
    
    if (badgeView) {
        [self.scrollView addSubview:badgeView];
    }
}

- (void) addScrollView {
    CGFloat width = self.frame.size.width - self.contentMargin * 2;
    CGFloat height = self.frame.size.height;
    CGRect frame = CGRectMake(self.contentMargin, 0, width, height);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.scrollsToTop = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
}

//根据模式定义选中时的效果
- (void)makeStyle {
    CGRect frame = CGRectZero;
    if (self.style == HGMenuViewStyleDefault) {
        return;
    }
    if (self.style == HGMenuViewStyleLine) {
        self.progressHeight = self.progressHeight > 0 ? self.progressHeight : 2.0;
        frame = CGRectMake(0, self.frame.size.height - self.progressHeight - self.progressViewBottomSpace, self.scrollView.contentSize.width, self.progressHeight);
    }else {
        self.progressHeight = self.progressHeight > 0 ? self.progressHeight : self.frame.size.height * 0.8;
        frame = CGRectMake(0, (self.frame.size.height - self.progressHeight)/2, self.scrollView.contentSize.width, self.progressHeight);
        self.progressViewCornerRadius = self.progressViewCornerRadius > 0 ? self.progressViewCornerRadius : self.progressHeight / 2.0;
    }
    
    //根据模式定义不同选中时不同的效果
    [self addProgressViewWithFrame:frame isTriangle:(self.style == HGMenuViewStyleTriangle) hasBorder:(self.style == HGMenuViewStyleSegmented) hollow:(self.style == HGMenuViewStyleFloodHollow) cornerRadius:self.progressViewCornerRadius];
}

- (void) addProgressViewWithFrame:(CGRect)frame isTriangle:(BOOL)isTriangle hasBorder:(BOOL)hasBorder hollow:(BOOL)isHollow cornerRadius:(CGFloat)cornerRadius {
    HGProgressView *pView = [[HGProgressView alloc] initWithFrame:frame];
    pView.itemFrames = [self convertProgressWidthsToFrames];
    pView.color = self.lineColor.CGColor;
    pView.isTriangle = isTriangle;
    pView.hasBorder = hasBorder;
    pView.hollow = isHollow;
    pView.cornerRadius = cornerRadius;
    pView.naughty = self.progressViewIsNaughty;
    pView.speedFactor = self.speedFactor;
    pView.backgroundColor = [UIColor clearColor];
    self.progressView = pView;
    [self.scrollView insertSubview:self.progressView atIndex:0];
}

- (void)reload {
    [self.frames removeAllObjects];
    [self.progressView removeFromSuperview];
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [self addItems];    //将items加入scrollView中
    [self makeStyle];   //根据模式当选中时的模式
    [self addBadgeViews];   //添加红色小点角标
}

- (void)selectItemAtIndex:(NSInteger)index {
    NSInteger tag = index + HGMenuItemTagOffset;
    NSInteger currentIndex = self.selItem.tag - HGMenuItemTagOffset;
    self.selectIndex = index;
    if (index == currentIndex || !self.selItem) {
        return;
    }
    
    //选中的Item
    HGMenuItem *item = (HGMenuItem *)[self viewWithTag:tag];
    [self.selItem setSelected:NO withAnimation:NO];
    self.selItem = item;
    [self.selItem setSelected:YES withAnimation:NO];
    [self.progressView setProgressWithOutAnimate:index];
    
    if ([self.delegate respondsToSelector:@selector(menuView:didSelectedIndex:currentIndex:)]) {
        [self.delegate menuView:self didSelectedIndex:index currentIndex:currentIndex];
    }
    [self refreshContenOffset];
}

//item的状态、细节设置，加入scrollView中
- (void) addItems {
    [self calculateItemFrames];//计算Menu的item的frame的值
    
    for (int i = 0; i < self.titlesCount; i ++) {
        CGRect frame = [self.frames[i] CGRectValue];
        HGMenuItem *item = [[HGMenuItem alloc] initWithFrame:frame];
        item.tag = (i + HGMenuItemTagOffset);
        item.delegate = self;
        item.text = [self.dataSource menuView:self titleAtIndex:i];
        item.textAlignment = NSTextAlignmentCenter;
        item.userInteractionEnabled = YES;
        item.backgroundColor = [UIColor clearColor];
        item.normalSize = [self sizeForState:HGMenuItemStateNormal atIndex:i];  //normal状态下字体大小
        item.selectedSize = [self sizeForState:HGMenuItemStateSelected atIndex:i];
        item.normalColor = [self colorForState:HGMenuItemStateNormal atIndex:i];        //normal状态下字体颜色
        item.selecetedColor = [self colorForState:HGMenuItemStateSelected atIndex:i];
        item.speedFactor = self.speedFactor;    //速度因数
        
        if (self.fontName) {
            item.font = [UIFont fontWithName:self.fontName size:item.selectedSize];
        }else {
            item.font = [UIFont systemFontOfSize:item.selectedSize];
        }
        if ([self.dataSource respondsToSelector:@selector(menuView:initialMenuItem:atIndex:)]) {
            item = [self.dataSource menuView:self initialMenuItem:item atIndex:i];
        }
        if (i == 0) {
            [item setSelected:YES withAnimation:NO];
            self.selItem = item;
        }else {
            [item setSelected:NO withAnimation:NO];
        }
        [self.scrollView addSubview:item];
    }
}


//选中与非选中状态下MenuItem的title的size状态变化
- (CGFloat)sizeForState:(HGMenuItemState)state atIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(menuView:titleSizeForState:atIndex:)]) {
        return [self.delegate menuView:self titleSizeForState:state atIndex:index];
    }
    return 15.0f;
}

//选中与非选中状态下MenuItem的title的color状态变化
- (UIColor *)colorForState:(HGMenuItemState)state atIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(menuView:titleColorForState:atIndex:)]) {
        return [self.delegate menuView:self titleColorForState:state atIndex:index];
    }
    return [UIColor blackColor];
}

//Menu的item的frame设值
- (void) resetFramesFromIndex:(NSInteger)index {
    [self.frames removeAllObjects];
    
    [self calculateItemFrames]; //计算Menu的scrollview的frame值
    for (NSInteger i = index; i < self.titlesCount; i ++) {//item和badge的frame设值
        [self resetItemFrame: i];
        [self resetBadgeFrame:i];
    }
    
    if (!self.progressView.superview) {
        return;
    }
    
    //进度条frame设值
    CGRect frame = self.progressView.frame;
    frame.size.width = self.scrollView.contentSize.width;
    if (self.style == HGMenuViewStyleLine || self.style == HGMenuViewStyleTriangle) {
        frame.origin.y = self.frame.size.height - self.progressHeight - self.progressViewBottomSpace;
    }else {
        frame.origin.y = (self.scrollView.frame.size.height - frame.size.height)/2.0;
    }
    
    self.progressView.frame = frame;
    self.progressView.itemFrames = [self convertProgressWidthsToFrames];
    [self.progressView setNeedsDisplay];
}

//计算所有item的frame值(还有menu的ScrollView的width值)，主要是为了适配所有item的宽度之和小于屏幕宽的情况
//这里与后面的 `-addItems` 做了重复的操作，并不是很合理
- (void)calculateItemFrames {
    CGFloat contentWidth = [self itemMarginAtIndex:0];  //Menu的Item的间隙值
    
    for (int i = 0; i < self.titlesCount; i ++) {
        CGFloat itemW = 60.0f;
        if ([self.delegate respondsToSelector:@selector(menuView:widthForItemAtIndex:)]) {
            itemW = [self.delegate menuView:self widthForItemAtIndex:i];//title的字体宽度
        }
        CGRect frame = CGRectMake(contentWidth, 0, itemW, self.frame.size.height);
        [self.frames addObject:[NSValue valueWithCGRect:frame]];
        contentWidth += itemW + [self itemMarginAtIndex:i +1];
    }
    
    //如果总宽度小于屏幕宽,重新计算frame,为item间添加间距
    if (contentWidth < self.scrollView.frame.size.width) {
        CGFloat distance = self.scrollView.frame.size.width - contentWidth;
        CGFloat (^shiftDis)(int);
        switch (self.layoutMode) {
            case HGMenuViewLayoutModeScatter:{
                    CGFloat gap = distance / (self.titlesCount +1);
                    shiftDis = ^CGFloat(int index) {
                        return gap * (index +1);
                    };
                }
                break;
                
            case HGMenuViewLayoutModeLeft:{
                shiftDis = ^CGFloat(int index) {
                    return 0.0f;
                };
            }
                break;
                
            case HGMenuViewLayoutModeRight:{
                shiftDis = ^CGFloat(int index){
                    return distance;
                };
            }
                break;
            
            case HGMenuViewLayoutModeCenter:{
                shiftDis = ^CGFloat(int index) {
                    return distance / 2;
                };
            }
                break;
                
            default:
                break;
        }
        
        for (int i = 0; i < self.frames.count; i ++) {
            CGRect frame = [self.frames[i] CGRectValue];
            frame.origin.x += shiftDis(i);
            self.frames[i] = [NSValue valueWithCGRect:frame];
        }
        contentWidth = self.scrollView.frame.size.width;
    }
    
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.frame.size.height);//顶部导航栏的frame大小
}

- (CGFloat) itemMarginAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(menuView:itemMarginAtIndex:)]) {
        return  [self.delegate menuView:self itemMarginAtIndex:index];
    }
    return 0.0;
}

- (void) resetItemFrame:(NSInteger) index {
    HGMenuItem *item = (HGMenuItem *)[self viewWithTag:(HGMenuItemTagOffset + index)];
    CGRect frame = [self.frames[index] CGRectValue];
    item.frame = frame;
    
    if ([self.delegate respondsToSelector:@selector(menuView: didLayoutItemFrame:atIndex:)]) {
        [self.delegate menuView:self didLayoutItemFrame:item atIndex:index];
    }
    
}

//设置Menu上的角标frame
- (void) resetBadgeFrame:(NSInteger)index {
    CGRect frame = [self.frames[index] CGRectValue];
    UIView *badgeView = [self.scrollView viewWithTag:(HGBadgeViewTagOffset + index)];
    if (badgeView) {
        CGRect badgeFrame = [self badgeViewAtIndex: index].frame;
        badgeFrame.origin.x += frame.origin.x;
        badgeView.frame = badgeFrame;
    }
}

//返回Menu上的角标
- (UIView *)badgeViewAtIndex:(NSInteger)index {
    if (![self.dataSource respondsToSelector:@selector(menuView:badgeViewAtIndex:)]) {
        return nil;
    }
    UIView *badgeView = [self.dataSource menuView:self badgeViewAtIndex:index];
    if (!badgeView) {
        return nil;
    }
    badgeView.tag = index + HGBadgeViewTagOffset;
    return badgeView;
}

//计算proress的frame存放在数组中
- (NSArray *)convertProgressWidthsToFrames {
    if (!self.frames.count) {
        NSAssert(NO, @"BUG SHOULDN'T COME HERE!!");
    }
    
    if (self.progressWidths.count < self.titlesCount) {
        return self.frames;
    }
    
    NSMutableArray *progressFrames = [NSMutableArray array];
    NSInteger count = (self.frames.count <= self.progressWidths.count) ? self.frames.count : self.progressWidths.count;
    for (int i = 0; i < count; i ++) {
        CGRect itemFrame = [self.frames[i] CGRectValue];
        CGFloat progressWidth = [self.progressWidths[i] floatValue];
        CGFloat x = itemFrame.origin.x + (itemFrame.size.width - progressWidth) / 2;
        CGRect progressFrame = CGRectMake(x, itemFrame.origin.y, progressWidth, 0);
        [progressFrames addObject:[NSValue valueWithCGRect:progressFrame]];
    }
    return progressFrames.copy;
}

#pragma mark -- HGMenuItemDelegate
- (void)didPressedMenuItem:(HGMenuItem *)menuItem {
    //当前选的Item和现在Item是不是一样的
    if (self.selItem == menuItem) { //当前选中的和以前选中的一样
        if ([self.delegate respondsToSelector:@selector(menuView:didSelectedIndex:currentIndex:)]) {
            [self.delegate menuView:self didSelectedIndex:-1 currentIndex:-1];
        }
        return;
    }
    
    CGFloat progress = menuItem.tag - HGMenuItemTagOffset;
    [self.progressView moveToPostion:progress];
    
    NSInteger currentIndex = self.selItem.tag - HGMenuItemTagOffset;
    if ([self.delegate respondsToSelector:@selector(menuView:didSelectedIndex:currentIndex:)]) {
        [self.delegate menuView:self didSelectedIndex:menuItem.tag -HGMenuItemTagOffset currentIndex:currentIndex];
    }
    
    [menuItem setSelected:YES withAnimation:YES];
    [self.selItem setSelected:NO withAnimation:YES];
    self.selItem = menuItem;
    
    NSTimeInterval delay = self.style == HGMenuViewStyleDefault ? 0 : 0.3f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //让选中的item位于中间
        [self refreshContenOffset];
    });
}

- (void)refreshContenOffset {
    CGRect frame = self.selItem.frame;
    CGFloat itemX = frame.origin.x;
    CGFloat width = self.scrollView.frame.size.width;
    CGSize contentSize = self.scrollView.contentSize;
    
    if (itemX > width/2) {//超过屏幕一半后的处理
        CGFloat targetX;
        if ((contentSize.width - itemX) <= width/2) {
            targetX = contentSize.width - width;
        }else {
            targetX = frame.origin.x - width/2 + frame.size.width/2;
        }
        //应该有更好的解决方法
        if (targetX + width > contentSize.width) {
            targetX = contentSize.width - width;
        }
        [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    }else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}



@end
