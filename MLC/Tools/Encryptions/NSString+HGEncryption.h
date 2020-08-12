//
//  NSString+HGEncryption.h
//  MLC
//
//  Created by Harley Huang on 16/3/2020.
//  Copyright © 2020 HuangGang'sMac. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HGEncryption)

///MD5 加密
- (NSString *)md5Encryption;

///Base64 编码
- (NSString *) base64Encode;

/// Base64 解码
- (NSString *) base64Decode;

@end

NS_ASSUME_NONNULL_END
