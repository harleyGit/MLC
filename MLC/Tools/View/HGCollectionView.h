//
//  HGCollectionView.h
//  HGSWB
//
//  Created by 黄刚 on 2018/8/1.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HGCollectionType)
{
    HGCollectionTypeCommon
};


@interface HGCollectionView : UIView
- (instancetype) initWithFrame:(CGRect)frame viewLayout:(UICollectionViewFlowLayout *) layout;
@end
