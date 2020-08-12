//
//  HGNetworking.m
//  HGSWB
//
//  Created by 黄刚 on 2018/7/7.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGNetworking.h"

@interface HGNetworking()

@end

@implementation HGNetworking

- (ShuWenData)shuWenData {
    ShuWenData shuWen;
    shuWen.baseUrl = (char *)[SWBaseUrl UTF8String];//转化为char
    
    NSString *timeStamp = [HGTools currentTimestamp:1000];
    shuWen.timeStamp = (char *)[timeStamp UTF8String];;
    
    NSString *signature = [NSString stringWithFormat:@"%@%@%@", SWSecretKey, timeStamp, SWAccessKey];
    shuWen.signature = (char *)[signature cStringUsingEncoding:NSUTF8StringEncoding];
    return shuWen;
}

#pragma mark - NSURLSession Get请求
+ (void) requestWithUrl:(NSString *) url success:(void (^)(id successModel))success failure:(void (^)(NSError *error))failure {
    //对请求路径的说明
    //http://120.25.226.186:32812/login?username=520it&pwd=520&type=JSON
    //协议头+主机地址+接口名称+？+参数1&参数2&参数3
    //协议头(http://)+主机地址(120.25.226.186:32812)+接口名称(login)+？+参数1(username=520it)&参数2(pwd=520)&参数3(type=JSON)
    //GET请求，直接把请求参数跟在URL的后面以？隔开，多个参数之间以&符号拼接
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];

    dispatch_queue_t queue = dispatch_queue_create("net.huanggang.GCDQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //根据会话对象，创建一个任务
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                //此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                SWBaseModel *baseModel = [[SWBaseModel alloc] initWithDictionary:dict error:nil];
                success(baseModel);
            }else {
                NSLog(@"------------>>>  GET 请求错误！！");
                failure(error);
            }
        }];
        //执行任务
        [dataTask resume];
    });
}

#pragma mark - NSURLSession Post请求
- (void) requestWithUrl:(NSString *)url wayType:(NSString *) way parameters:(NSString *) parameters {
    //对请求路径的说明
    //http://120.25.226.186:32812/login
    //协议头+主机地址+接口名称
    //协议头(http://)+主机地址(120.25.226.186:32812)+接口名称(login)
    //POST请求需要修改请求方法为POST，并把参数转换为二进制数据设置为请求体
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *URL = [NSURL URLWithString:url];
    //创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    //修改请求方法为POST
    request.HTTPMethod = way;
    //设置请求体
    request.HTTPBody = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    
    
    /**
     根据会话对象创建一个Task(发送请求）
     completionHandler回调（请求完成【成功|失败】的回调）
     param data 响应体信息（期望的数据）
     param response 响应头信息，主要是对服务器端的描述
     param error 错误信息，如果请求失败，则error有值
     return 请求数据
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"------------>POST: %@", dict);
        }
    }];
    [dataTask resume];
}

//GET的URL处理
+ (NSString *) shuWenPortUrl:(NSString *)port  parameters:(NSDictionary *) parameters {
    NSString *timeStamp = [HGTools currentTimestamp:SecondType_Millisecond];
    NSString *signatureStr = [NSString stringWithFormat:@"%@%@%@", SWSecretKey, timeStamp, SWAccessKey];
    //MD5加密时间戳
    NSString *signature = MD5ForLower32Bate(signatureStr);
    NSString *sat = [NSString stringWithFormat:@"access_key=%@&signature=%@&timestamp=%@", SWAccessKey, signature, timeStamp];//@"access_key": SWAccessKey
    
    //参数拼接,可以使用enumerateKeysAndObjectsUsingBlock进行拼接
    for (NSString *key in parameters.allKeys) {
        sat = [sat stringByAppendingFormat:@"&%@=%@", key, parameters[key]];
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@%@", SWBaseUrl, port, sat];
    
    return URL;
}


@end
