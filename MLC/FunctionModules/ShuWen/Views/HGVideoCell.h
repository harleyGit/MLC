//
//  HGVideoCell.h
//  HGSWB
//
//  Created by 黄刚 on 2019/2/9.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGVideoCell : UITableViewCell

@property(nonatomic, strong) HGVideoListModel *model;
@property(nonatomic, copy) void (^imageViewCallBack)(UIView *fatherView);

- (void)refreshCellStatus;

@end

NS_ASSUME_NONNULL_END
