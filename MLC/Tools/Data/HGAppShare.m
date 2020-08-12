//
//  HGAppShare.m
//  HGSWB
//
//  Created by 黄刚 on 2018/9/2.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGAppShare.h"

@implementation HGAppShare
static HGAppShare *_appShare = nil;
+ (instancetype) shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appShare = [[super allocWithZone:nil] init];
    });
    
    return _appShare;
}

- (void) shareKind:(AppShareKind)shareKind contentKind:(AppShareContentKind) contentKind content:(id)content {
    switch (shareKind) {
        case AppShareKindWeiXin:
            [self weixinForContentKind:contentKind content:content];
            break;
            
        default:
            break;
    }
}

- (void) weixinForContentKind:(AppShareContentKind)contentKind content:(id)content {
    SendMessageToWXReq *req    = [[SendMessageToWXReq alloc] init];
    WXMediaMessage *medMessage = [WXMediaMessage message];
    switch (contentKind) {
        case AppShareContentKindText:
            if ([content isKindOfClass:[HGShareText class]]) {
                [self weixinShareText:content sendRequetToWeixin:req];
            }else {
                return;
            }
            break;
        case AppShareContentKindWeb:
            if ([content isKindOfClass:[HGShareWeb class]]) {
                [self weixinShareWeb:content sendRequetToWeixin:req messageContent:medMessage];
            }else {
                return;
            }
            break;
        case  AppShareContentKindMusic:
            if ([content isKindOfClass:[HGShareMusic class]]) {
                [self weixinShareMusic:content sendRequetToWeixin:req messageContent:medMessage];
            }else {
                return;
            }
        break;
        case  AppShareContentKindVideo:
            if ([content isKindOfClass:[HGShareVideo class]]) {
                [self weixinShareVideo:content sendRequetToWeixin:req messageContent:medMessage];
            }else {
                return;
            }
            break;
        case  AppShareContentKindPicture:
            if ([content isKindOfClass:[HGSharePicture class]]) {
                [self weixinSharePicture:content sendRequetToWeixin:req messageContent:medMessage];
            }else {
                return;
            }
            break;
            
        default:
            break;
    }
}


//分享文本到微信
- (void) weixinShareText:(HGShareText *)content sendRequetToWeixin:(SendMessageToWXReq *) req {
    req.bText = content.isDocument;      // 指定为发送文本
    req.text = content.text;             // 要发送的文本
    req.scene = content.wxScene;         // 指定发送到会话
    
    [WXApi sendReq:req];
//    [WXApi sendReq:req completion:nil];
}

//分享网页到微信
- (void) weixinShareWeb:(HGShareWeb *)content sendRequetToWeixin:(SendMessageToWXReq *) req messageContent:(WXMediaMessage *) medMessage{
    WXWebpageObject *webPageObj = [WXWebpageObject object];
    webPageObj.webpageUrl = content.webURL;
    
    medMessage.title = content.title;                   // 标题
    medMessage.description = content.describe;          // 描述
    [medMessage setThumbImage: content.copressImage];   // 缩略图
    medMessage.mediaObject = webPageObj;                // 完成发送对象实例
    
    req.bText = content.isDocument;                     // 是否是文档
    req.scene = content.wxScene;                        // 分享到会话
    req.message = medMessage;

    [WXApi sendReq:req];                                // 发送分享信息
//    [WXApi sendReq:req completion:nil];
}

//分享音乐到微信
- (void) weixinShareMusic:(HGShareMusic *)content sendRequetToWeixin:(SendMessageToWXReq *) req messageContent:(WXMediaMessage *) medMessage {
    WXMusicObject *music = [WXMusicObject object];// 创建多媒体对象
    music.musicUrl = content.musicURL;            // 分享链接
    
    req.bText =  content.isDocument;              // 是否是文档
    req.scene = content.wxScene;
    req.message = medMessage;

    //创建分享内容对象
    medMessage.title = content.title;             // 分享标题
    medMessage.description = content.describe;    // 分享描述
    [medMessage setThumbImage:content.copressImage];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
    medMessage.mediaObject = music;               // 完成发送对象实例

    [WXApi sendReq:req];                          // 发送分享信息
//    [WXApi sendReq:req completion:nil];

}

//分享Video到微信
- (void) weixinShareVideo:(HGShareVideo *)content sendRequetToWeixin:(SendMessageToWXReq *) req messageContent:(WXMediaMessage *) medMessage {
    WXVideoObject *video = [WXVideoObject object];  // 创建多媒体对象
    video.videoUrl = content.videoURL;              // 分享链接

    req.bText = content.isDocument;                 // 是否是文档
    req.scene = 0;
    req.message = medMessage;

    medMessage.title = content.title;                // 分享标题
    medMessage.description = content.describe;       // 分享描述
    [medMessage setThumbImage: content.copressImage];// 分享图片,使用SDK的setThumbImage方法可压缩图片大小
    medMessage.mediaObject = video;                  // 完成发送对象实例

    [WXApi sendReq:req];                             // 发送分享信息
//    [WXApi sendReq:req completion:nil];
}


- (void) weixinSharePicture:(HGSharePicture *)content sendRequetToWeixin:(SendMessageToWXReq *) req messageContent:(WXMediaMessage *) medMessage {
    
    NSData *data = UIImagePNGRepresentation(content.image); // 图片真实数据内容
    WXImageObject *imageObject = [WXImageObject object];    // 多媒体消息中包含的图片数据对象
    imageObject.imageData = data;
   
    [medMessage setThumbImage: content.copressImage];       // 设置消息缩略图的方法
    medMessage.mediaObject = imageObject;                   // 多媒体数据对象，可以为WXImageObject，WXMusicObject，WXVideoObject，WXWebpageObject等。

    req.bText = content.isDocument;
    req.message = medMessage;
    req.scene = content.wxScene;
    
    [WXApi sendReq:req];
//    [WXApi sendReq:req completion:nil];
}



//在整个文件被加载到运行时，在main函数调用之前调用
+ (void)load {
    printf("\n\n HGAppShare load()");
}

// 该类第一次调用该类时调用
+ (void)initialize {
    printf("\n HGAppShare initialize()\n\n\n");
    [HGAppShare shareInstance];
}

#pragma mark -- 冷酷派
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (_appShare) {
        return _appShare;
    }
    return [HGAppShare shareInstance];
}

+ (instancetype)new {
    if (_appShare) {
        return _appShare;
    }
    return [HGAppShare shareInstance];
}

- (id) copyWithZone:(NSZone *) zone {
    if (_appShare) {
        return _appShare;
    }
    return [HGAppShare shareInstance];
}


- (id) mutableCopyWithZone:(NSZone *)zone {
    if (_appShare) {
        return  _appShare;
    }
    return [HGAppShare shareInstance];
}

#pragma mark -- 温柔派
//+(instancetype) alloc __attribute__((unavailable("call sharedInstance instead")));
//
//+(instancetype) new __attribute__((unavailable("call sharedInstance instead")));
//
//-(instancetype) copy __attribute__((unavailable("call sharedInstance instead")));
//
//-(instancetype) mutableCopy __attribute__((unavailable("call sharedInstance instead")));


@end
