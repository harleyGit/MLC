//
//  RSAEncryption.h
//  MLC
//
//  Created by Harley Huang on 16/3/2020.
//  Copyright © 2020 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSAEncryptor : NSObject

+ (instancetype) sharedRSAEncryptor;

///加载公钥
- (void) loadPublicKey:(NSString *)publicKeyPath;



/// 生成密钥对
/// @param keySize 密钥尺寸，可选数值(512/1024/2048)
- (void) generateKeyPair:(NSUInteger)keySize;


/// 加载私钥
/// @param privateKeyPath p12文件路径
/// @param password p12文件密码
- (void)loadPrivateKey:(NSString *)privateKeyPath password:(NSString *)password;


/// 加密数据
/// @param plainData 明文数据
- (NSData *) encryptData:(NSData *)plainData;



/// 解密数据
/// @param cipherData 密文数据
- (NSData *) decryptData:(NSData *)cipherData;


///公钥加密数据
- (NSData *)encryptWithPublicKey;

///私钥解密
- (void) decryptWithPrivateKey: (NSData *)dataToDecrypt;

@end

NS_ASSUME_NONNULL_END
