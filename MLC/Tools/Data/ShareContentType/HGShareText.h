//
//  HGShareText.h
//  HGSWB
//
//  Created by 黄刚 on 2018/9/4.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGShareText : NSObject

//文本内容
@property(nonatomic, copy)   NSString    *text;
//是否是文档
@property(nonatomic, assign) BOOL        isDocument;
//场景，如：微信朋友圈、收藏、聊天界面
@property(nonatomic, assign) int         wxScene;

@end
