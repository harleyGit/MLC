//
//  HGCustomTableCell.m
//  HGSWB
//
//  Created by 黄刚 on 2018/9/4.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGCustomTableCell.h"

@implementation HGCustomTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
