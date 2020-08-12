//
//  HGMyDataSource.m
//  HGSWB
//
//  Created by 黄刚 on 2018/9/1.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGMyDataSource.h"

@interface HGMyDataSource()

@property(nonatomic, copy) NSArray       *functions;

@end

@implementation HGMyDataSource
#pragma mark -- LAZY
- (NSArray *)functions {
    if (!_functions) {
        _functions = @[@[[HGMyModel new]],
                       @[@"my_setting", @"设置"],
                       @[@[@"my_nightMode", @"夜间模式"], @[@"my_collect", @"我的收藏"], @[@"my_scan", @"扫一扫"], @[@"my_drafits", @"草稿箱"], @[@"my_AttentionWords", @"关注的超话"],@[@"my_service", @"客服中心"]],
                       @[@[@"my_browsingHistory", @"浏览记录"], @[@"my_welfare", @"每日福利"]],
                       @[@[@"my_welfare", @"加密"]],
                       ];
    }
    return _functions;
}

- (instancetype)initWithIdentifier:(NSString *)identifier configureBlock:(CellConfigureBefore)before {
    self = [super init];
    if (self) {
        _cellIdentifier = identifier;
        _cellConfigureBefore = [before copy];
    }
    return self;
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (MyCellKindPersonalWeiBo == section) {
        return 1;
    }else if (MyCellKindSetting == section) {
        return 1;
    }else if (MyCellKindTrace == section) {
        return 2;
    }else if (MyCellKindEncrypt == section) {
        return  1;
    }
    return 6;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    HGMyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    if (!cell) {
        cell = [[HGMyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellIdentifier];
    }
    
    id model = [self modelsAtIndexPath:indexPath];
    if (self.cellConfigureBefore) {
        self.cellConfigureBefore(cell, model, indexPath);
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[HGMyTableCell class]]) {
        NSArray *models = nil;
        
        if (indexPath.section == 0) {
            [(HGMyTableCell *)cell bindModel:self.myM];
        }else if(indexPath.section == 1) {
            models = self.functions[indexPath.section];
            [(HGMyTableCell *)cell bindModel: models];
        }else {
            models = self.functions[indexPath.section][indexPath.row];
            [(HGMyTableCell *)cell bindModel: models];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *models = nil;
    if (indexPath.section == 0) {
        models = self.functions[indexPath.section][0];
    }else if(indexPath.section == 1) {
        models = self.functions[indexPath.section];
    }else {
        models = self.functions[indexPath.section][indexPath.row];
    }
    
    return  [HGMyTableCell heightWithModel: models];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MyCellKindEncrypt +1;
}


#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(pushToNextControllerForCellIndexPath:)]) {
        [self.delegate pushToNextControllerForCellIndexPath:indexPath];
    }
}



//设置每个section的分割视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = HGDEFAULT_COLOR;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (MyCellKindPersonalWeiBo == section) {
        return 0.0f;
    }
    return  30.0f;
}

- (id)modelsAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataArray.count > indexPath.row? self.dataArray[indexPath.row] :nil;
}

@end
