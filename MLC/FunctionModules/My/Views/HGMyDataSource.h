//
//  HGMyDataSource.h
//  HGSWB
//
//  Created by 黄刚 on 2018/9/1.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, MyCellKind) {
    MyCellKindPersonalWeiBo,    //个人微博信息
    MyCellKindSetting,              //设置
    MyCellKindFunction,             //功能
    MyCellKindTrace,                //浏览痕迹
    MyCellKindEncrypt,              //加密
};

@protocol HGMyDataSourceDelegate <NSObject>

- (void) pushToNextControllerForCellIndexPath:(NSIndexPath *)indexPath;

@end

typedef void (^CellConfigureBefore) (id cell, id model, NSIndexPath *indexPath);

@interface HGMyDataSource : NSObject<UITableViewDelegate, UITableViewDataSource>


@property(nonatomic, weak) id <HGMyDataSourceDelegate> delegate;

@property(nonatomic, retain) HGMyModel *myM;
//存放model数组
@property(nonatomic, copy) NSArray *dataArray;
//cell标识符
@property(nonatomic, retain)IBInspectable NSString *cellIdentifier;
//cell配置
@property(nonatomic, copy)CellConfigureBefore cellConfigureBefore;

- (instancetype) initWithIdentifier:(NSString *)identifier configureBlock:(CellConfigureBefore)before;


@end
