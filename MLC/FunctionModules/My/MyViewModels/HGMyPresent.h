//
//  HGMyPresent.h
//  HGSWB
//
//  Created by 黄刚 on 2018/9/5.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyPresentDelegate <NSObject, HGNetworkingDelegate>

- (void) switchToJSONForData:(id)data;

@end

@interface HGMyPresent : NSObject

@property(nonatomic, retain) HGMyModel *myModel;
@property(nonatomic, weak) id <MyPresentDelegate> delegate;


/**
 获取用户资料以及用户最新的一条微博
 */
- (void) loadDataFor_UsersDomain_show;

@end
