//
//  HGMyTableCell.h
//  HGSWB
//
//  Created by 黄刚 on 2018/9/5.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGCustomTableCell.h"

@interface HGMyTableCell : HGCustomTableCell

@property(nonatomic, assign) MyCellKind cellKind;


+ (CGFloat) heightWithModel:(id)model;
- (void) bindModel:(id)model;
@end
