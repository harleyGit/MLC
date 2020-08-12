//
//  HGMyController.m
//  HGSWB
//
//  Created by 黄刚 on 2018/8/3.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGMyController.h"
#import <WebKit/WebKit.h>
//引入微信头文件
#import "WXApi.h"
#import "WXApiObject.h"

NSString * const kAPPBundleShortVersionString = @"CFBundleShortVersionString";
#define gkey            @"ZbKIPhQj$kgPs*ud0#DF^&U1"
static NSString *const cellID = @"HGMyTableCell";

@interface HGMyController ()<HGNetworkingDelegate, HGMyDataSourceDelegate>


@property(nonatomic, retain) UITableView *personalTable;
@property(nonatomic, retain) HGMyDataSource *myDataSource;

@property(nonatomic, retain) HGMyModel *mm;

@end

@implementation HGMyController

#pragma mark -- LAZY

- (UITableView *) personalTable {
    if (!_personalTable) {
        _personalTable = [[UITableView alloc] initWithFrame:CGRectZero];
        _personalTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _personalTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _personalTable;
}

- (HGMyDataSource *)myDataSource {
    if (!_myDataSource) {
        _myDataSource = [[HGMyDataSource alloc] initWithIdentifier:cellID configureBlock:^(HGMyTableCell *cell, id model, NSIndexPath* indexPath) {
            if (indexPath.section == 0) {
                cell.cellKind = MyCellKindPersonalWeiBo;
            }else {
                cell.cellKind = MyCellKindSetting;
            }
        }];
        _myDataSource.delegate = self;
    }
    return _myDataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的";
    [self viewAndDataBind];
    [self layoutViews];
    [self getWeiUserInfo];
    
}

- (void) viewAndDataBind {
    
    self.personalTable.dataSource = self.myDataSource;
    self.personalTable.delegate   = self.myDataSource;
}


//微博获得用户信息
- (void) getWeiUserInfo {
    HGUserManager *um = [HGUserManager sharedInstance];
    NSString *access_token = um.access_token;
    NSString *uid = um.uid;
    HGNetworking *nw = [HGNetworking shareInstance];
    nw.delegate = self;
    
    [HGNetworking requestMethodType:RequestMethodTypeGet url:[HGWeiBoPortManager users_show] parameters:@{@"access_token": access_token, @"uid": uid}];
}

- (void) layoutViews {
    
    [self.view addSubview:self.personalTable];
    self.personalTable.backgroundColor = HGDEFAULT_COLOR;
    [self.personalTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.bottom.and.right.equalTo(self.view);
    }];
}


#pragma mark -- HGNetworkingDelegate
- (void)requestData:(NSData *)data {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    id jsonStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    SLog(@"%@", jsonStr);

    HGUserManager *user = [HGUserManager sharedInstance];
    [user setDomain:jsonStr[@"domain"]];
    
    self.mm = [[HGMyModel alloc] initWithString:string error:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{

        self.myDataSource.myM = self.mm;

        [self.personalTable reloadData];

    });
}


#pragma mark -- HGMyDataSourceDelegate
- (void)pushToNextControllerForCellIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            HGMyInformationController *mic = [HGMyInformationController new];
            mic.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mic animated:YES];
        }
            break;
            
        case 1:{
            HGSetController *sc = [HGSetController new];
            [self.navigationController pushViewController:sc animated:YES];
        }
            break;
            
        case 4:{
            HGEncryptController *ec = [HGEncryptController new];
            [self.navigationController pushViewController:ec animated:YES];
        }
            
        default:
            break;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
