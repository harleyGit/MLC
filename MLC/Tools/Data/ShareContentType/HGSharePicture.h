//
//  HGSharePicture.h
//  HGSWB
//
//  Created by 黄刚 on 2018/9/4.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGSharePicture : NSObject

//图片
@property(nonatomic, retain) UIImage  *image;
//压缩图片
@property(nonatomic, retain) UIImage  *copressImage;
//场景
@property(nonatomic, assign) int      wxScene;
//是否是文档
@property(nonatomic, assign) BOOL     isDocument;

@end
