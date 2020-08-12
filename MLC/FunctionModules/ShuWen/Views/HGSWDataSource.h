//
//  HGSWTableView.h
//  HGSWB
//
//  Created by 黄刚 on 2018/8/23.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellConfigure) (id cell, id model);

@interface HGSWDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, copy)   CellConfigure cellConfigure;


- (instancetype) initWithIdentifier:(NSString *) identifier cellConfigure:(CellConfigure) cellConfigure;


- (void)addDataArray:(NSArray *)datas;

- (id) modelsAtIndexPath:(NSIndexPath *) indexPath;

@end
