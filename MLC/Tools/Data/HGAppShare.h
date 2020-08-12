//
//  HGAppShare.h
//  HGSWB
//
//  Created by 黄刚 on 2018/9/2.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark -- 分享到App类型
typedef NS_ENUM(NSInteger, AppShareKind) {
    AppShareKindWeiXin,
    AppShareKindQQ,
    AppShareKindWeiBo,
};

#pragma mark -- 分享内容内型
typedef NS_ENUM(NSInteger, AppShareContentKind) {
    AppShareContentKindText,
    AppShareContentKindWeb,
    AppShareContentKindMusic,
    AppShareContentKindVideo,
    AppShareContentKindPicture,
};

#pragma mark -- 分享内容元素
//文本
typedef struct {
    __unsafe_unretained NSString    *text;
}ShareContentText;
CG_INLINE ShareContentText
ShareContentTextMake(NSString *text){
    ShareContentText contentText;
    contentText.text = text;
    return contentText;
}

@interface HGAppShare : NSObject

+ (instancetype) shareInstance;

- (void) shareKind:(AppShareKind)shareKind contentKind:(AppShareContentKind) contentKind content:(id)content;

@end
