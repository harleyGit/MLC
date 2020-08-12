//
//  HGAuthorizeLoginController.m
//  HGSWB
//
//  Created by 黄刚 on 2018/10/14.
//  Copyright © 2018 HuangGang'sMac. All rights reserved.
//

#import "HGAuthorizeLoginView.h"

@interface HGAuthorizeLoginView ()<UIWebViewDelegate,HGNetworkingDelegate>

@property(nonatomic, strong) UIWebView   *webView;

@end

@implementation HGAuthorizeLoginView

#pragma mark -- LAZY

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.bounds];//.view
        _webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _webView.delegate = self;
    }
    return _webView;
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    [self getWeiBoAccesstoken];
//    [self layoutViews];
//
//}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self getWeiBoAccesstoken];
        [self layoutViews];
    }
    return self;
}


- (void) getWeiBoAccesstoken {
    NSString *url = [NSString stringWithFormat:@"%@oauth2/authorize?client_id=%@&redirect_uri=%@", WBauthURL,WBAppKey,WBAuthorizationCallbackPage];
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:0 timeoutInterval:-1];
    [self.webView loadRequest: request];
    
}


- (void) getWeiBoToken:(NSString *)code {
    //    WKWebView解析html字符串：https://www.jianshu.com/p/42d818e85805
    //请求用户授权Token
    HGNetworking *network = [HGNetworking shareInstance];
    network.delegate = self;
    
    //获取授权过的Access Token
    [HGNetworking requestMethodType:RequestMehtodTypePost url:[NSString stringWithFormat:@"%@oauth2/access_token?", WBauthURL] parameters: @{@"client_id": WBAppKey, @"client_secret": WBAppSecret, @"grant_type":@"authorization_code", @"code":code, @"redirect_uri": WBAuthorizationCallbackPage}];
}

#pragma mark -- UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *absoluteURL = request.URL.absoluteString;
    
    if ([absoluteURL hasPrefix:WBAuthorizationCallbackPage]) {
        //截取Code
        NSRange range = [absoluteURL rangeOfString:@"code="];
        NSUInteger location = range.location + range.length;
        NSString *code = [absoluteURL substringFromIndex:location];
        
        //进行授权请求
        if ([code length]) {
            [self getWeiBoToken:code];
            [self.webView removeFromSuperview];
            self.webView = nil;
        }
    }
    
    return YES;
}



#pragma mark -- HGNetworkingDelegate
- (void)requestData:(NSData *)data {

        HGUserManager *um = [HGUserManager sharedInstance];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
        if (![HGTools isBlankForString:dic[@"access_token"]]) {
            [um setAccess_token: dic[@"access_token"]];
            [um setUid:dic[@"uid"]];
            [[HGUserManager sharedInstance] printPath];
        }
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self removeAuthorizeloginView];
}

- (void) layoutViews {
    [self addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.bottom.equalTo(self);
    }];
}

- (void) show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void) removeAuthorizeloginView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView removeFromSuperview];
        [self removeFromSuperview];
    });
}

@end
