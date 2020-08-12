//
//  NSString+HGEncryption.m
//  MLC
//
//  Created by Harley Huang on 16/3/2020.
//  Copyright © 2020 HuangGang'sMac. All rights reserved.
//

#import "NSString+HGEncryption.h"


@implementation NSString (HGEncryption)


/// 返回二进制 Bytes 流的字符串表示形式
/// @param bytes 二进制 Bytes 数组
/// @param length 数组长度
- (NSString *)stringFromBytes:(uint8_t *)bytes length:(int)length {
    NSMutableString *strM = [NSMutableString string];
    
    for (int i = 0; i < length; i ++) {
        [strM appendFormat:@"%02x", bytes[i]];
    }
    
    return  strM.copy;
}

- (NSString *)md5Encryption {
    
    const char *str = self.UTF8String;
    //创建字符串数组接收MD5值
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    //计算MD5值（结果储存在result数组中）
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    //获取MD5加密后的值
    return [self stringFromBytes: buffer length: CC_MD5_DIGEST_LENGTH];
}

- (NSString *)base64Encode {
    //把字符串转换为二进制数据
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    //NSDataBase64Encoding64CharacterLineLength:每64个字符插入\r或\n
    //对二进制数据进行base64编码，返回编码后的字符串
    return  [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString *)base64Decode {
    //将base64编码后的字符串『解码』为二进制数据
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    //二进制数据转换为字符串返回
    return  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


@end
