//
//  HGSWTableView.m
//  HGSWB
//
//  Created by 黄刚 on 2018/8/23.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGSWDataSource.h"

@interface HGSWDataSource()

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) IBInspectable NSString *cellIdentifier;

@end

@implementation HGSWDataSource

- (instancetype) initWithIdentifier:(NSString *) identifier cellConfigure:(CellConfigure) cellConfigure {
    self = [super init];
    if (self) {
        _cellIdentifier = identifier;
        _cellConfigure  = [cellConfigure copy];
    }
    return self;
    
}

- (void)addDataArray:(NSArray *)datas{
    if (!datas) {
        return;
    }
    
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    
    [self.dataArray addObjectsFromArray:datas];
}

- (id)modelsAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataArray.count > indexPath.row ? self.dataArray[indexPath.row] : nil;
}


#pragma mark -- UITableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    HGNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    if (!cell) {
        cell = [[HGNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    
    id model = [self modelsAtIndexPath:indexPath];
    if (self.cellConfigure) {
        self.cellConfigure(cell, model);
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return !self.dataArray.count ?  0 : self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  140.0f;
}


#pragma mark -- LAZY
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:2];
    }
    
    return _dataArray;
}

@end
