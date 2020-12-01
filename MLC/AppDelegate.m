//
//  AppDelegate.m
//  HGSWB
//  Created by 黄刚 on 2018/7/7.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//
#import "AppDelegate.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *bundle = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];//[[NSBundle mainBundle]bundleIdentifier];
    NSLog(@"----->%@",bundle);
    
    //RSA加密测试
    [self encryptionTest];
        
    self.window.rootViewController = [HGRootController new];
    [self.window makeKeyAndVisible];
    
    /*
    //微博授权页验证
    HGUserManager *um = [HGUserManager sharedInstance];
    if ([HGTools isBlankForString:um.access_token]) {
        HGAuthorizeLoginView *alc = [[HGAuthorizeLoginView alloc] initWithFrame: [UIScreen mainScreen].bounds];
        [alc show];
    }
     */
    
    [AppDelegate weixinShareRegister];
    
    [AppDelegate registerRemoteNotification];
    
    return YES;
}

- (void) encryptionTest {
    NSString *userName = @"harleyhuang";
    NSString *encryName = userName.md5Encryption;
    NSLog(@"---->>名字md5加密： %@", encryName);
    
    NSString *base64encodeName = userName.base64Encode;
    NSLog(@"---->>名字base64编码： %@", base64encodeName);
    NSString *base64decodeName = base64encodeName.base64Decode;
    NSLog(@"---->>名字base64解码： %@", base64decodeName);
    
    
    //加载RSA公钥
    //可以从网络获取证书,如果证书存在于钥匙串中，也可以在钥匙串中查找证书
    [[RSAEncryptor sharedRSAEncryptor] loadPublicKey:[[NSBundle mainBundle] pathForResource:@"rsaPublicCert.der" ofType:nil]];
    [[RSAEncryptor sharedRSAEncryptor] loadPrivateKey:[[NSBundle mainBundle] pathForResource:@"rsaPrivate.p12" ofType:nil] password:@"harley109"];
    
    //加密过程
    NSData *encryData = [[RSAEncryptor sharedRSAEncryptor] encryptData:[@"hello world" dataUsingEncoding:NSUTF8StringEncoding]];
    //解密过程
    NSData *decryData = [[RSAEncryptor sharedRSAEncryptor] decryptData:encryData];
    //解密结果
    NSString *res = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
    NSLog(@"RSA 解密结果： %@", res);
    /*
    //下面加密和解密方法有问题加密后无法解密
    [[RSAEncryptor sharedRSAEncryptor] generateKeyPair:1024];
    NSData *encryData1 = [[RSAEncryptor sharedRSAEncryptor] encryptWithPublicKey];
    [[RSAEncryptor sharedRSAEncryptor] decryptWithPrivateKey:encryData1];
     */

}



//NOTE: 9.0 以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    
    // 接受传过来的参数
//    NSString *text = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"URL Scheme" message:text preferredStyle: UIAlertControllerStyleAlert];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"标题" style:UIAlertActionStyleDefault handler:nil];
//    [ac addAction:action1];
//
//    [self.window.rootViewController presentViewController:ac animated:YES completion:nil];
    
    return [WXApi handleOpenURL:url delegate:self];

}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//注册远程通知之后，获取device token成功回调
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceStr = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceStr = [deviceStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"success get deviceToken: %@", deviceStr);
}

//获取device token失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"fail get deviceToken: %@", error.description);
}


//注册APNs消息
+ (void) registerRemoteNotification {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 //Xcode8 编译会调用
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (!error) {
                    NSLog(@"request notification authorization succeeded!");
                }
            }];
        }
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else   //Xcode7 编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings: settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings: settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}


#pragma mark -- UNUserNotificationCenterDelegate
//iOS10 收到通知(本地和远端)

//App处于前台接收通知时
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    //收到推送的请求
    UNNotificationRequest *request = notification.request;
   
    //收到推送的内容
    UNNotificationContent *content = request.content;
    
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    
    //收到推送消息body
    NSString *body = content.body;
    
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    
    //推送消息的副标题
    NSString *subtitle = content.subtitle;
    
    //推送消息的标题
    NSString *title = content.title;
    
    //本地和远程通知判断
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //远程通知处理Code
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
    }else {
        // 判断为本地通知
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    //提醒用户有badge、sound、Alert三种类型选择，需要执行下面的方法
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
}

//App通知的点击事件
//用户点击消息才会触发，如果用户长按（3DTouch）、弹出Action页面等并不会触发。点击Action的时候会触发！
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    
    //收到推送的内容
    UNNotificationContent *content = request.content;
    
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    
    //收到推送消息body
    NSString *body = content.body;
    
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    
    //推送消息的副标题
    NSString *subtitle = content.subtitle;
    
    //推送消息的标题
    NSString *title = content.title;
    
    //本地和远程通知判断
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //远程通知处理Code
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
    }else {
        // 判断为本地通知
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    //UserNotificationsDemo[1765:800117] Warning: UNUserNotificationCenter delegate received call to -userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: but the completion handler was never called.
    completionHandler(); // 系统要求执行这个方法
}


#pragma mark -- 微信分享
+ (void) weixinShareRegister {
    
    //注册appID
    [WXApi registerApp:WXShareAppID enableMTA:false];
//    [WXApi registerApp:WXShareAppID universalLink:nil];
}

#pragma  mark -- 融云
- (void) configurationRongCloud {
    
}

#pragma mark --WeiXinSDK  Delegate
//微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面
- (void)onReq:(BaseReq *)req {
    
}

//第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
//从微信分享过后点击返回应用的时候调用
- (void)onResp:(BaseResp *)resp {
    
    SendMessageToWXResp *sendResp = (SendMessageToWXResp *)resp;
    
    NSString *str = [NSString stringWithFormat:@"%d", sendResp.errCode];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"回调信息" message:[NSString stringWithFormat:@"onResp errCode:  %@", str] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    [ac addAction:okAction];
    [self.window.rootViewController presentViewController:ac animated:YES completion:nil];
}

//程序要发消息给微信，那么需要调用WXApi的sendReq函数
//-(BOOL) sendReq:(BaseReq*)req{}



@end
