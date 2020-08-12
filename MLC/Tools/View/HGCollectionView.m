//
//  HGCollectionView.m
//  HGSWB
//
//  Created by 黄刚 on 2018/8/1.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGCollectionView.h"

@interface HGCollectionView()<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>{
    UICollectionViewFlowLayout *flowLayout;
}

@property(nonatomic, retain) UICollectionView           *collectionView;

@end

@implementation HGCollectionView
static NSString * const identifier = @"HGCollectionViewCell";


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = HGDEFAULT_COLOR;
        
        //注册HGCollectionViewCell
        [_collectionView registerClass:[HGCollectionViewCell class] forCellWithReuseIdentifier:identifier];
        //注册headerView
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (instancetype) initWithFrame:(CGRect)frame viewLayout:(UICollectionViewFlowLayout *) layout {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HGDEFAULT_COLOR;
        
        flowLayout = layout;
        self.collectionView.frame = frame;
        [self addSubview:self.collectionView];
    }
    return self;
}


#pragma mark -- UICollectionViewDelegate
//section 个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  9;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HGCollectionViewCell *cell = (HGCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HGCollectionViewCell" forIndexPath:indexPath];
    
    cell.label.text = [NSString stringWithFormat:@"{%ld,%ld}",indexPath.section,indexPath.row];
    
    cell.backgroundColor = [UIColor yellowColor];
    
    return cell;

}

//每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake(90, 130);
}

//footer的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return CGSizeMake(10, 10);
//}

//heaer的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return  CGSizeMake(10, 10);
//}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

//每一个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//每一个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return  0;
}

//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “sectionHeader”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
    headerView.backgroundColor = [UIColor grayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
    label.text = @"collectionView的头部";
    label.font = [UIFont systemFontOfSize:20];
    [headerView addSubview:label];
    return headerView;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HGCollectionViewCell *cell = (HGCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *msg = cell.label.text;
    NSLog(@"%@",msg);
}

@end
