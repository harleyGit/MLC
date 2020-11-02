//
//  Constants.h
//  HGSWB
//
//  Created by 黄刚 on 2018/7/7.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//
#ifndef Constants_h
#define Constants_h



//-------------系统类---------------//
#import <SDWebImage.h>
#import <ZFPlayer/ZFPlayer.h>
#import <MJExtension.h>
#import <AFNetworking.h>
#import <CommonCrypto/CommonCrypto.h>
#import <JSONModel.h>
#import <Masonry.h>
#import <MJRefresh.h>
#import <ReactiveObjC.h>
//微信API
#import <WXApi.h>
#import <WXApiObject.h>


//-------------分类---------------//
#import "UIImage+Tool.h"
#import "HGSearchBar.h"
#import "NSString+Tool.h"
#import "HGRichTextView.h"
#import "UIView+AnimationExtend.h"
#import "NSObject+HGKVO.h"
#import "NSString+HGEncryption.h"



//-------------单例类---------------//
#import "HGUserManager.h"
#import "HGProgressHUD.h"
#import "HGAppShare.h"
#import "RSAEncryptor.h"


//-------------自定义类---------------//
#import "HGRefreshFooter.h"
#import "ZFPlayerView.h"
#import "HGBaseViewModel.h"
#import "HGPortManager.h"
#import "HGNetWorkManager.h"
#import "HGMenuView.h"
#import "HGPageController.h"
#import "HGProgressView.h"
#import "HGMenuItem.h"
#import "HGBaseController.h"
#import "HGNavigationBar.h"
#import "HGRefreshGifHeader.h"
#import "HGScrollView.h"


//-------------->  Model 类
//--分享Model类
#import "HGShareText.h"
#import "HGShareWeb.h"
#import "HGShareMusic.h"
#import "HGShareVideo.h"
#import "HGSharePicture.h"



//--微博Models类
#import "HGWBBaseModel.h"
#import "HGMyModel.h"
#import "HGMyInformationModel.h"

//--数闻Models类
#import "HGHomeNewsModel.h"
#import "HGHomeJokeInfoModel.h"
#import "HGVideoListModel.h"
#import "HGHomeTitleViewModel.h"
#import "HGHomeTitleRequest.h"
#import "SWBaseModel.h"
#import "SWModels.h"
#import "SWCategoriesModel.h"
#import "SWCategoryModel.h"
#import "HGAllNewsModel.h"
#import "HGEachNewsModel.h"
#import "HGHomeTitleModel.h"
#import "HGDetailController.h"




//-------------->  View 类
//--视频View类
#import "HGVideoController.h"


//--微博View类
#import "HGMyDataSource.h"
#import "HGMyTableCell.h"
#import "HGAuthorizeLoginView.h"
#import "HGMyInformationController.h"

//--数闻View 类
#import "HGContentNewsCell.h"
#import "HGHomeNewsCell.h"
#import "HGHomeJokeCell.h"
#import "HGScrollMenuView.h"
#import "HGCollectionView.h"
#import "HGCollectionViewCell.h"
#import "HGRootController.h"
#import "HGWeiBoController.h"
#import "HGMyController.h"
#import "ShuWenController.h"
#import "HGNewsCell.h"
#import "HGSWDataSource.h"


//-------------->  ViewModel 类
//--微博ViewModel 类


//--数闻ViewModel 类
#import "HGVideoCell.h"
#import "HGHomeNewsRequest.h"
#import "HGHomeNewsCellViewModel.h"
#import "HGMainViewModel.h"
#import "HGFunctionVM.h"
#import "HGFunctionDetailVM.h"
#import "HGShuWenPresenter.h"

//-------------->  网络 类
#import "HGNetworking.h"
#import "HGNetworking+WeiBo.h"
#import "HGWeiBoPortManager.h"


//-------------->  工具类
#import "HGTools.h"
#import "HGNavigationController.h"
#import "HGCustomAliertView.h"
#import "HGSizeManager.h"




//-------------Pod导入---------------//




#pragma mark -- 微博
/*
 ----------------------微博------------------------
 接口：http://open.weibo.com/apps/4281003029/privilege
 // 17133853768, harely109
 App Key：4281003029
 App Secret：a2a78d303966f8f8ce59fa5acabc37b1
 */
#define WBAppKey                                @"4281003029"
#define WBAppSecret                             @"a2a78d303966f8f8ce59fa5acabc37b1"
//授权回调页
#define WBAuthorizationCallbackPage             @"http://open.weibo.com"
#define WBCancleAuthorizationCallbackPage       @"http://pvp.qq.com/web201605/herolist.shtml"

#define WBauthURL         @"https://api.weibo.com/"


#pragma mark -- 融云
//开发环境Appkey、AppSecret
#define RCAppkey       @"lmxuhwaglz1zd"
#define RCAppSecret    @"FenUveyvdlBl0"

//生产环境Appkey、AppSecret
//#define RCAppkey       @"z3v5yqkbz6l60"
//#define RCAppSecret    @"Nm5Jn3Untw"



#pragma  mark -- 支付宝
#define ZFBAppName        @"跑特优思"
#define ZFBAPPID          @"2018090261300156"


//授权回调页
#define ZFBAuthorizationCallbackPage            @"https://open.alipay.com/platform/home.htm?from=zhuzhanrukou20160818"




#pragma mark -- 微信
//分享
#define WXShareAppID    @"wx0b185468299d2be7"



#pragma  mark -- 数闻
/*
 ----------------------数闻-----------------------
 url：https://fenfa.shuwen.com/docs/api_category?spm=fenfa.0.0.1.gM5Hmj
 HGSWB                  ID:NJRFNb
 */
#define SWBaseUrl    @"https://api.xinwen.cn/news/"
#define SWAccessKey  @"V2nxEDdaWrGjGcrT"
#define SWSecretKey  @"0f5ecc8133394140b2c38c745009352e"



#pragma  mark -- 头条
#define HN_IID                              @"17769976909"
#define HN_DEVICE_ID                        @"41312231473"

/*
 Access Key:V2nxEDdaWrGjGcrTSecret
 Key:0f5ecc8133394140b2c38c745009352e
 
 ----------------------干货集中营-------------------
 url：http://gank.io/api
 */


#endif /* Constants_h */
