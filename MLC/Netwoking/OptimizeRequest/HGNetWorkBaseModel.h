//
//  HGNetWorkBaseModel.h
//  HGSWB
//
//  Created by 黄刚 on 2019/1/13.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGNetWorkBaseModel : NSObject

@property(nonatomic, copy) NSString *urlString;
@property(nonatomic, assign) BOOL isPost;
@property(nonatomic, assign) BOOL showNetErrorHUD;
@property(nonatomic, strong) NSDictionary *extraParameters;

+ (instancetype) netWorkModelWithURLString:(NSString *)urlString isPost:(BOOL)isPost;
- (void)sendRequest;
- (void)sendRequestWithSuccess:(SuccessHanddle)success failure:(FailureHandle)failure;

@end

NS_ASSUME_NONNULL_END
