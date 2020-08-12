//
//  HGShareWeb.h
//  HGSWB
//
//  Created by 黄刚 on 2018/9/4.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGShareWeb : NSObject

//标题
@property(nonatomic, copy)   NSString *title;
//描述
@property(nonatomic, copy)   NSString *describe;
//网址
@property(nonatomic, copy)   NSString *webURL;
//场景
@property(nonatomic, assign) int      wxScene;
//是否是文档
@property(nonatomic, assign) BOOL     isDocument;
//压缩图片
@property(nonatomic, retain) UIImage  *copressImage;

@end
