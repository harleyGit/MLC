//
//  HGTools.m
//  HGSWB
//
//  Created by 黄刚 on 2018/7/8.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGTools.h"

@implementation HGTools

//原始尺寸
static CGRect oldframe;

+ (BOOL) isBlankForString:(NSString *) str {
    //没有初始值
    if (!str) {
        return YES;
    }
    
    //为NSNULL
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [str stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

#pragma mark - URL获取Image的Size
//参考资料：https://www.cnblogs.com/LynnAIQ/p/6132812.html
+(CGSize) pngImageSizeWithURL:(id) imageURL {
    NSURL *URL = nil;
    
    if ([imageURL isKindOfClass:[NSURL class]]) {
        URL = imageURL;
    }
    
    if ([imageURL isKindOfClass:[NSString class]]) {
        URL = [NSURL URLWithString:imageURL];
    }
    
    //URL为空，返回CGSiZero
    if (URL == nil) {
        return CGSizeZero;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    //pathExtension 获得文件后缀名(不带‘.’), lowercaseString 转换为小写字符串;  获取后缀名
    NSString *pathExtendsion     = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if ([pathExtendsion isEqualToString:@"png"]) {
        size = [self getPNGImageSizeWithRequest:request];
    }else if ([pathExtendsion isEqual:@"gif"]) {
        size = [self getGIFImageSizeWithRequest:request];
    }else {
        size = [self getJPGImageSizeWithRequest:request];
    }
    
    //若获取文件头失败，发送异步请求原图
    if (CGSizeEqualToSize(CGSizeZero, size)) { //判断两个CGSize是否一样大, 类似的还有判断两个CGPoint是否x和y是否都相等:CGPointEqualToPoint
        
        NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            size = image.size;
        }
    }
    
    return size;
}

+ (CGSize)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    CGFloat actualHeight = image.size.height;
    CGFloat actualWidth  = image.size.width;
    CGFloat imgRatio     = actualWidth / actualHeight;
    
    CGFloat maxRatio     = newSize.width / newSize.height;
    
    if (imgRatio != maxRatio) {
        if (imgRatio < maxRatio) {
            imgRatio     = newSize.height / actualHeight;
            actualHeight = newSize.height;
            actualWidth  = imgRatio * actualWidth;
        }else {
            imgRatio     = newSize.width / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth  = newSize.width;
        }
    }
    CGSize size = CGSizeMake(actualWidth, actualHeight);
    return size;
}

//获取PNG图片的大小
+ (CGSize) getPNGImageSizeWithRequest:(NSMutableURLRequest *)request {
    //根据field修改设置value, field要严格遵守http协议
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data.length == 8) {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        //将data中的range数据复制到&w1中的缓冲区中
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        
        int w = (w1 << 24)+(w2 << 16)+(w3 << 8) + w4;
        
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        
        int h = (h1 << 24)+(h2 << 16)+(h3 << 8) + h4;
        
        return CGSizeMake(w, h);
    }
    
    return CGSizeZero;
}

//获取GIF图片的Size
+ (CGSize) getGIFImageSizeWithRequest:(NSMutableURLRequest *)request {
    //设置指定HTTP的头文件
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data.length == 4) {
        short w1 = 0, w2 = 0;
        
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        
        short h = h1 + (h2 << 8);
        
        return CGSizeMake(w, h);
    }
    
    return CGSizeZero;
}

//获取jpg图片的大小
+ (CGSize) getJPGImageSizeWithRequest:(NSMutableURLRequest *)request {
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
     NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&w1 range:NSMakeRange(0x5f, 0x1)];
        
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    }else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) { //两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                
                return CGSizeMake(w, h);
            }
        }else {
            return  CGSizeZero;
        }
    }
    
}


#pragma mark - 获得数闻签名
+ (NSString *)SWSignatureForTime: (NSString *)timeStamp {
    NSString *signature = [NSString stringWithFormat:@"%@%@%@", SWSecretKey, timeStamp, SWAccessKey];
    
    return MD5ForLower32Bate(signature);
}

//获取当前时间戳
+ (NSString *)currentTimestamp:(SecondType) secondType{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = 0.0;
    if (secondType == SecondType_Second) {
        time=[date timeIntervalSince1970];  //秒
    }else if (secondType == SecondType_Millisecond) {
        time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    }else {
        time=[date timeIntervalSince1970]*1000*1000; //纳秒
    }
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

+ (NSString *) changeTimeFormatForTiemstamp:(NSString *)time {
    
    //时间戳是10位
    NSTimeInterval interval = [time doubleValue] / 1000.0;
    NSDate         *date    = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy:MM:dd-HH:mm:ss"];
    NSString        *dateStr   = [formatter stringFromDate:date];
    
    return dateStr;
}


+ (NSData *) transformToDataForURLString:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    return data;
}

+ (void)scanBigImageWithImageView:(UIImageView *)currentImageview alpha:(CGFloat)alpha {
    //  当前imageview的图片
    UIImage *image = currentImageview.image;
    //  当前视图
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //  背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //  当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
    oldframe = [currentImageview convertRect:currentImageview.bounds toView:window];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:alpha]];
    
    //  此时视图不会显示
    [backgroundView setAlpha:0];
    //  将所展示的imageView重新绘制在Window中
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    [imageView setImage:image];
    imageView.contentMode =UIViewContentModeScaleAspectFit;
    [imageView setTag:1024];
    [backgroundView addSubview:imageView];
    //  将原始视图添加到背景视图中
    [window addSubview:backgroundView];
    
    
    //  添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    //  动画放大所展示的ImageView
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
        //宽度为屏幕宽度
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, y, width, height)];
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  恢复imageView原始尺寸
 *
 *  @param tap 点击事件
 */
+(void)hideImageView:(UITapGestureRecognizer *)tap{
    
    UIView *backgroundView = tap.view;
    //  原始imageview
    UIImageView *imageView = [tap.view viewWithTag:1024];
    //  恢复
    [UIView animateWithDuration:0.4 animations:^{
        [imageView setFrame:oldframe];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
}

@end
