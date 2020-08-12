//
//  HGShuWenPresenter.h
//  HGSWB
//
//  Created by 黄刚 on 2018/8/21.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShuWenPresenterDelegate<NSObject>

- (void) attchModels:(id) newsM;

@end

@interface HGShuWenPresenter : HGMainViewModel

@property(nonatomic, weak) id<ShuWenPresenterDelegate> presenterDelegate;


- (instancetype) initWithView:(UIView *) view;

- (void) attachView: (UIView *)view;

- (instancetype)initWithParameters:(NSDictionary *)parameters  successModel:(SuccessModel) successModel;

- (void) shuWenOfParameters:(NSMutableDictionary *) parameters successModel:(SuccessModel) successModel;

@end
