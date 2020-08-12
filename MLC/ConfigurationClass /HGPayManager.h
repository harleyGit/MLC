//
//  HGPayManager.h
//  HGSWB
//
//  Created by 黄刚 on 2018/9/4.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGPayManager : NSObject

+ (id) sharePayManager;

- (void) handleOrderAliPayWithParams:(NSDictionary *) parameters;

@end
