//
//  RSAEncryption.m
//  MLC
//
//  Created by Harley Huang on 16/3/2020.
//  Copyright © 2020 HuangGang'sMac. All rights reserved.
//

#import "RSAEncryptor.h"

//填充模式
#define kTypeOfWrapPading  kSecPaddingPKCS1// kSecPaddingNone

//公钥/私钥标签
#define kPublicKeyTag   "com.RSAEncryption.publicKey\0"
#define kPrivateKeyTag  "com.RSAEncryption.privateKey\0"

//uint8_t：无符号8位整型
static const uint8_t publicKeyIdentifier[]  = kPublicKeyTag;
static const uint8_t privateKeyIdentifier[] = kPrivateKeyTag;


@interface RSAEncryptor()
{
    //公钥引用
    SecKeyRef publicKeyRef;
    //私钥引用
    SecKeyRef privateKeyRef;
}

//公钥标签
@property(nonatomic, retain) NSData *publicTag;
//私钥标签
@property(nonatomic, retain) NSData *privateTag;

@end

@implementation RSAEncryptor

+ (instancetype)sharedRSAEncryptor {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return  instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.privateTag = [[NSData alloc] initWithBytes:privateKeyIdentifier length:sizeof(privateKeyIdentifier)];
        self.publicTag = [[NSData alloc] initWithBytes:publicKeyIdentifier length:sizeof(publicKeyIdentifier)];
    }
    return  self;
}


//加载公钥
- (void) loadPublicKey:(NSString *)publicKeyPath {
    //NSAssert:捕获一个错误, 让程序崩溃, 同时报出错误提示
    NSAssert(publicKeyPath.length != 0, @"公钥路径为空");
    
    //删除当前公钥
    if (publicKeyRef) {
        CFRelease(publicKeyRef);
    }
    
    //根据公钥证书der文件制作成证书对象
    NSData *certificateData = [NSData dataWithContentsOfFile:publicKeyPath];
    //根据二进制数据生成一个SecCertificateRef类型的证书
    //证书对象引用
    SecCertificateRef certificateRef = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
    NSAssert(certificateRef != NULL, @"公钥文件错误");
    
    //信任策略 SecPolicyCreateBasicX509 用来获取取策略对象
    SecPolicyRef policyRef = SecPolicyCreateBasicX509();
    //评估信任的对象
    SecTrustRef trustRef;
    

    //用证书和策略创建信任对象（trust）。
    //如果存在中间证书或者锚证书，应把这些证书都包含在certificate数组中并传递给SecTrustCreateWithCertificates函数。
    //这样会加快评估的速度
    OSStatus status = SecTrustCreateWithCertificates(certificateRef, policyRef, &trustRef);
    NSAssert(status == errSecSuccess, @"创建信任管理对象失败");
    
    //信任结果
    SecTrustResultType trustResult;
    //评估一个信任对象：评估指定证书和策略的信任管理是否有效
    status = SecTrustEvaluate(trustRef, &trustResult);
    NSAssert(status == errSecSuccess, @"信任评估失败");
    
    //评估之后返回公钥子证书
    publicKeyRef = SecTrustCopyPublicKey(trustRef);
    NSAssert(publicKeyRef != NULL, @"公钥创建失败");
    
    //处理信任结果（trust result）。如果信任结果是kSecTrustResultInvalid，kSecTrustResultDeny，kSecTrustResultFatalTrustFailure，你无法进行处理。如果信任结果是kSecTrustResultRecoverableTrustFailure，你可以恢复这个错误
    if (trustResult == kSecTrustResultRecoverableTrustFailure) {
        //从信任中恢复
        recoverFromTrustFailure(trustRef);
        //NSAssert(trustResult == kSecTrustResultRecoverableTrustFailure, @"信任失败");
    }
    
    if (certificateRef) {
        CFRelease(certificateRef);
    }
    if (policyRef) {
        CFRelease(policyRef);
    }
    if (trustRef) {
        CFRelease(trustRef);
    }
}


//加载私钥
- (void)loadPrivateKey:(NSString *)privateKeyPath password:(NSString *)password {
    NSAssert( privateKeyPath.length != 0, @"私钥路径为空");
    
    //删除当前私钥
    if (privateKeyRef) {
        CFRelease(privateKeyRef);
    }
    
    NSData *pkcs12Data = [NSData dataWithContentsOfFile:privateKeyPath];
    CFDataRef inPkcs12Data = (__bridge CFDataRef)pkcs12Data;
    CFStringRef passwordRef = (__bridge CFStringRef)password;
    
    //从 PKCS #12 证书中提取标示和证书
    SecIdentityRef myIdentity;
    SecTrustRef myTrust;
    //以PKCS#12格式导出或以PKCS#12格式导入时使用的密码(由CFStringRef对象表示)
    const void *keys[] = {kSecImportExportPassphrase};
    const void *values[] = {passwordRef};
    //创建要传给 SecPKCS12Import的包含密码的字典
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    
    //从PKCS #12数据中导出证书、密钥、信任，放到数组中
    //OSStatus: 系统框架Security/SecureTransport.h中定义的错误码
    OSStatus status = SecPKCS12Import(inPkcs12Data, optionsDictionary, &items);
    
    if (status == noErr) {
        //从数组中取出第一个字典，并从这个字典中取出身份和信任
        //SecPKCS12Import方法为PKCS #12数据中的每一个条目（身份或证书）返回一个字典
        //在这个例子中被导出的身份是数组中的第一个(item #0)
        CFDictionaryRef myIdentifityAndTrust = CFArrayGetValueAtIndex(items, 0);
        myIdentity = (SecIdentityRef)CFDictionaryGetValue(myIdentifityAndTrust, kSecImportItemIdentity);
        //显示证书信息
        SLog(@"私钥证书信息： %@", copySummaryString(myIdentity));
        myTrust = (SecTrustRef)CFDictionaryGetValue(myIdentifityAndTrust, kSecImportItemTrust);
    }
    
    if (optionsDictionary) {
        CFRelease(optionsDictionary);
    }
    
    NSAssert(status == noErr, @"提取身份和信任失败");
    
    SecTrustResultType trustResult;
    //评估指定证书和策略的信任管理是否有效
    status = SecTrustEvaluate(myTrust, &trustResult);
    NSAssert(status == errSecSuccess, @"信任评估失败");
    
    //提取私钥
    status = SecIdentityCopyPrivateKey(myIdentity, &privateKeyRef);
    NSAssert(status == errSecSuccess, @"私钥创建失败");
    
    if (items) {
        CFRelease(items);
    }
    
    //return status
}


//显示证书信息
NSString *copySummaryString(SecIdentityRef identity) {
    SecCertificateRef myReturnedCertificate = NULL;
    //从证书中提取身份
    OSStatus status = SecIdentityCopyCertificate(identity, &myReturnedCertificate);
    if (status) {
        SLog(@"SecIdentityCopyCertificate failed.\n");
        return  NULL;
    }
    //从证书中获取概要信息
    CFStringRef certSummary = SecCertificateCopySubjectSummary(myReturnedCertificate);
    //转换string为NSString对象
    NSString *summaryString = [[NSString alloc] initWithString:(__bridge NSString *)certSummary];
    
    CFRelease(certSummary);
    
    return  summaryString;
}


//钥匙串的持久化引用
CFDataRef persistentRefForIdentity(SecIdentityRef identity) {
    OSStatus status = errSecSuccess;
    CFTypeRef persistent_ref = NULL;
    const void *keys[] = {kSecReturnPersistentRef, kSecValueRef};
    const void *values[] = {kCFBooleanTrue, identity};
    
    CFDictionaryRef dict = CFDictionaryCreate(NULL, keys, values, 2, NULL, NULL);
    status = SecItemAdd(dict, &persistent_ref);
    
    if (dict) {
        CFRelease(dict);
    }
    
    return  (CFDataRef)persistent_ref;
}


//从持久化引用的钥匙串中检索身份对象
SecIdentityRef identityForPersistentRef(CFDataRef persistent_ref) {
    CFTypeRef  identity_ref = NULL;
    
    const void *keys[] = {kSecClass, kSecReturnRef, kSecValuePersistentRef};
    const void *values[] = {kSecClassIdentity, kCFBooleanTrue, persistent_ref};
    
    CFDictionaryRef dict = CFDictionaryCreate(NULL, keys, values, 3, NULL, NULL);
    SecItemCopyMatching(dict, &identity_ref);
    
    if (dict) {
        CFRelease(dict);
    }
    
    return (SecIdentityRef)identity_ref;
}


//钥匙串中查找证书
void certificateInKeychain() {
    OSStatus status = errSecSuccess;
    CFTypeRef certificateRef = NULL;
    const char *certLabelString = "Remeo Montague";
    
    CFStringRef certLabel = CFStringCreateWithCString(NULL, certLabelString, kCFStringEncodingUTF8);
    const void *keys[] = {kSecClass, kSecAttrLabel, kSecReturnRef};
    const void *values[] = {kSecClassCertificate, certLabel, kCFBooleanTrue};
    CFDictionaryRef dict = CFDictionaryCreate(NULL, keys, values, 3, NULL, NULL);
    status = SecItemCopyMatching(dict, &certificateRef);
    
    if (status == errSecSuccess) {
        CFRelease(certificateRef);
        certificateRef = NULL;
    }
    
    if (dict) {
        CFRelease(dict);
    }
}



//解密
- (NSData *) decryptData:(NSData *)cipherData {
    OSStatus sanityCheck = noErr;
    size_t cipherBufferSize = 0;
    size_t keyBufferSize = 0;
    
    NSData *key = nil;
    uint8_t *keyBuffer = NULL;
   
    SecKeyRef privateKey = NULL;
    privateKey = [self getPrivateKeyRef];
    NSAssert(privateKey != NULL, @"私钥不存在");
    
    //计算缓冲区大小
    cipherBufferSize = SecKeyGetBlockSize(privateKey);
    keyBufferSize = [cipherData length];
    NSAssert(keyBufferSize <= cipherBufferSize, @"解密内容太大");
    
    //分配缓冲区
    keyBuffer = malloc(keyBufferSize * sizeof(uint8_t));
    memset((void *)keyBuffer, 0x0, keyBufferSize);
    
    //使用私钥解密
    sanityCheck = SecKeyDecrypt(privateKey, kTypeOfWrapPading, (const uint8_t *)[cipherData bytes], cipherBufferSize, keyBuffer, &keyBufferSize);
    
    NSAssert1(sanityCheck == noErr, @"解密错误，OSStatus == %d", sanityCheck);
    
    //生成明文数据
    key = [NSData dataWithBytes:(const void*)keyBuffer length:(NSUInteger)keyBufferSize];
    
    if (keyBuffer) {
        free(keyBuffer);
    }
    
    return key;
}


/// 获取私钥引用
- (SecKeyRef) getPrivateKeyRef {
    OSStatus sanityCheck = noErr;
    SecKeyRef privateKeyReference = NULL;
    
    if (privateKeyRef == NULL) {
        NSMutableDictionary *queryPrivateKey = [[NSMutableDictionary alloc] init];
        
        //设置私钥查询字典
        [queryPrivateKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
        [queryPrivateKey setObject:_privateTag forKey:(__bridge id)kSecAttrApplicationTag];
        [queryPrivateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrType];
        [queryPrivateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
        
        //获得密钥
        sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef)queryPrivateKey, (CFTypeRef *)&privateKeyReference);
        
        if (sanityCheck != noErr) {
            privateKeyReference = NULL;
        }
    }else{
        privateKeyReference = privateKeyRef;
    }
    
    return  privateKeyReference;
}

- (NSData *) encryptData:(NSData *)plainData {
    OSStatus sanityCheck = noErr;
    size_t cipherBufferSize = 0;
    size_t keyBufferSize = 0;
    
    NSAssert(plainData != nil, @"明文数据为空");
    NSAssert(publicKeyRef != nil, @"公钥为空");
    
    NSData *cipher = nil;
    //加密文本分配缓冲区
    uint8_t *cipherBuffer = NULL;
    
    //计算缓冲区大小
    cipherBufferSize = SecKeyGetBlockSize(publicKeyRef);
    keyBufferSize = [plainData length];
    
    if (kTypeOfWrapPading == kSecPaddingNone) {
        NSAssert(keyBufferSize <= cipherBufferSize, @"加密内容太大");
    } else {
        NSAssert(keyBufferSize <= (cipherBufferSize - 11), @"加密内容太大");
    }
    
    //分配缓冲区
    cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0x0, cipherBufferSize);
    
    //使用公钥加密
    sanityCheck = SecKeyEncrypt(publicKeyRef, kTypeOfWrapPading, (const uint8_t *)[plainData bytes], keyBufferSize, cipherBuffer, &cipherBufferSize);
    NSAssert(sanityCheck == noErr, @"加密错误，OSStatus == %d", sanityCheck);
    
    //生成密文数据
    cipher = [NSData dataWithBytes:(const void *)cipherBuffer length:(NSUInteger) cipherBufferSize];
    
    if (cipherBuffer) {
        free(cipherBuffer);
    }
    
    return  cipher;
}


///信任失败恢复
void recoverFromTrustFailure(SecTrustRef myTrust) {
    SecTrustResultType trustResult;
    //评估证书可信度。参考“获取策略对象并评估可信度”
    OSStatus status = SecTrustEvaluate(myTrust, &trustResult);
    
    CFAbsoluteTime trustTime, currentTime, timeIncrement, newTime;
    CFDateRef newDate;
    //检查信任评估结果是否是可恢复的失败
    if (trustResult == kSecTrustResultRecoverableTrustFailure) {
        //取得证书的评估时间（绝对时间）。如果证书在评估时已经过期了，则被认为无效
        trustTime = SecTrustGetVerifyTime(myTrust);
        //设置时间的递增量为1年（以秒计算）
        timeIncrement = 31536000;
        //取得当前时间的绝对时间
        currentTime = CFAbsoluteTimeGetCurrent();
        //设置新时间（第2次评估的时间）为当前时间减一年
        newTime = currentTime - timeIncrement;
        
        //检查评估时间是否大于1年前（最近一次评估是否1年前进行的）。
        //如果是，使用新时间（1年前的时间）进行评估，看证书是否在1年前就已经过期
        if (trustTime - newTime) {
            //把新时间转换为CFDateRef。
            //也可以用NSDate，二者是完全互通的，方法中的NSDate*参数，可以用CFDateRef进行传递；反之亦可
            newDate = CFDateCreate(NULL, newTime);
            //设置信任评估时间为新时间（1年前）
            SecTrustSetVerifyDate(myTrust, newDate);
            //再次进行信任评估。如果证书是因为过期（到期时间在1年内）导致前次评估失败，那么这次评估应该成功
            status = SecTrustEvaluate(myTrust, &trustResult);
        }
    }
    
    //再次检查评估结果。如果仍不成功，则需要做更进一步的操作，比如提示用户安装中间证书，或则友好地告知用户证书校验失败
    if (trustResult != kSecTrustResultProceed) {
        
    }
}


///生成密钥对
- (void) generateKeyPair:(NSUInteger)keySize {
    OSStatus  sanityCheck = noErr;
    publicKeyRef = NULL;
    privateKeyRef = NULL;
    
    NSAssert1(keySize == 512 || keySize == 1024 || keySize == 2048, @"密钥尺寸无效 %tu", keySize);
    
    //删除当前密钥对
    [self deleteAsymmetricKeys];
    
    //为SecKeyGeneratePair方法中的属性分配容器字典
    NSMutableDictionary *privateKeyAttr = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *publicKeyAttr  = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *keyPairAttr = [[NSMutableDictionary alloc] init];
    
    //定义的标识符字符串的NSData对象
    self.publicTag = [NSData dataWithBytes:publicKeyIdentifier length:strlen((const char *) publicKeyIdentifier)];
    self.privateTag = [NSData dataWithBytes:privateKeyIdentifier length:strlen((const char *) privateKeyIdentifier)];
    
    //设置密钥对的顶级字典
    //设置密钥对类型属性为RSA
    [keyPairAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    //设置密钥对长度为keySize(可以为1024)字节
    [keyPairAttr setObject:[NSNumber numberWithUnsignedInteger:keySize] forKey:(__bridge id)kSecAttrKeySizeInBits];
    
    //设置私钥字典
    //设置私钥的持久化属性（即是否存入钥匙串）为YES
    [privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
    //identifier放到私钥的dictionary中
    [privateKeyAttr setObject:self.privateTag forKey:(__bridge id)kSecAttrApplicationTag];
    
    //设置公钥字典
    //设置公钥的持久化属性（即是否存入钥匙串）为YES
    [publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
    //identifier放到公钥的dictionary中
    [publicKeyAttr setObject:self.publicTag forKey:(__bridge id)kSecAttrApplicationTag];
    
    //设置顶级字典属性
    //把私钥的属性集（dictionary）加到密钥对的属性集（dictionary）中
    [keyPairAttr setObject:privateKeyAttr forKey:(__bridge id)kSecPrivateKeyAttrs];
    //把公钥的属性集（dictionary）加到密钥对的属性集（dictionary）中
    [keyPairAttr setObject:publicKeyAttr forKey:(__bridge id)kSecPublicKeyAttrs];
    
    
    //产生密钥对
    sanityCheck = SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr, &publicKeyRef, &privateKeyRef);
    NSAssert((sanityCheck == noErr && publicKeyRef != NULL && privateKeyRef != NULL), @"生成密钥对失败");
    
    //释放不用的对象内存
    if (publicKeyRef) {
        CFRelease(publicKeyRef);
    }
    
    if (privateKeyRef) {
        CFRelease(privateKeyRef);
    }

}


///删除非对称密钥
- (void) deleteAsymmetricKeys {
    OSStatus sanityCheck = noErr;
    NSMutableDictionary *queryPublicKey = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *queryPrivateKey = [[NSMutableDictionary alloc] init];
    
    //设置公钥查询字典
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPublicKey setObject:_publicTag forKey:(__bridge  id)kSecAttrApplicationTag];
    [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    //设置私钥查询字典
    [queryPrivateKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPrivateKey setObject:self.privateTag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPrivateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    //删除私钥
    sanityCheck = SecItemDelete((__bridge CFDictionaryRef)queryPrivateKey);
    NSAssert1((sanityCheck == noErr || sanityCheck == errSecItemNotFound), @"删除私钥错误，OSStatus == %d", sanityCheck);
    
    //删除公钥
    sanityCheck = SecItemDelete((__bridge CFDictionaryRef)queryPrivateKey);
    NSAssert1((sanityCheck == noErr || sanityCheck == errSecItemNotFound), @"删除公钥错误，OSStatus == %d", sanityCheck);
    
    if (publicKeyRef) {
        CFRelease(publicKeyRef);
    }
    
    if (privateKeyRef) {
        CFRelease(privateKeyRef);
    }
}

///用公钥加密数据
- (NSData *)encryptWithPublicKey {
    OSStatus status = noErr;
    
    size_t cipherBufferSize;
    // 1 为加密文本分配缓冲区
    uint8_t *cipherBuffer;

    // [cipherBufferSize]
    // 2 指定要加密的文本
    const uint8_t dataToEncrypt[] = "the quick brown fox jumps "
    "over the lazy dog\0";
    size_t dataLength = sizeof(dataToEncrypt)/sizeof(dataToEncrypt[0]);

    // 3 定义SecKeyRef，用于公钥。
    SecKeyRef publicKey = NULL;

    // 4 定义NSData对象，存储公钥的identifier（见列表 2-8 的第1、3、8步），该id在钥匙串中唯一。
    NSData * publicTag = [NSData dataWithBytes:publicKeyIdentifier
                                        length:strlen((const char *)publicKeyIdentifier)];
    // 5 定义dictionary，用于从钥匙串中查找公钥。
    NSMutableDictionary *queryPublicKey =
    [[NSMutableDictionary alloc] init];

    // 6 设置dictionary的键－值属性。
    //属性中指定，钥匙串条目类型为“密钥”，
    //条目identifier为第4步中指定的字符串，密钥类型为RSA，函数调用结束返回查找到的条目引用。
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPublicKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];


    // 7 调用SecItemCopyMatching函数进行查找。
    status = SecItemCopyMatching
    ((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&publicKey);


    cipherBufferSize = SecKeyGetBlockSize(publicKey);
    cipherBuffer = malloc(cipherBufferSize);


    if (cipherBufferSize < sizeof(dataToEncrypt)) {
        // Ordinarily, you would split the data up into blocks
        // equal to cipherBufferSize, with the last block being
        // shorter. For simplicity, this example assumes that
        // the data is short enough to fit.
        printf("Could not decrypt.  Packet too large.\n");
        return NULL;
    }

    // 8 加密数据， 返回结果用PKCS1格式对齐。
    status = SecKeyEncrypt(    publicKey,
                           kSecPaddingPKCS1,
                           dataToEncrypt,
                           (size_t) dataLength,
                           cipherBuffer,
                           &cipherBufferSize
                           );

    //  Error handling
    //  Store or transmit the encrypted text

    if (publicKey) CFRelease(publicKey);

    NSData *encryptedData = [NSData dataWithBytes:cipherBuffer length:dataLength];

    free(cipherBuffer);

    return encryptedData;
}


///私钥解密
- (void) decryptWithPrivateKey: (NSData *)dataToDecrypt {
    NSString *strN = [[NSString alloc] initWithData:dataToDecrypt encoding:NSUTF8StringEncoding];
    NSLog(@"--->> %@",strN);
    OSStatus status = noErr;
    
    size_t cipherBufferSize = [dataToDecrypt length];
    uint8_t *cipherBuffer = (uint8_t *)[dataToDecrypt bytes];

    size_t plainBufferSize;
    uint8_t *plainBuffer;

    SecKeyRef privateKey = NULL;

    NSData * privateTag = [NSData dataWithBytes:privateKeyIdentifier
                                         length:strlen((const char *)privateKeyIdentifier)];

    NSMutableDictionary *queryPrivateKey = [[NSMutableDictionary alloc] init];

    // 1 设置放钥匙串中私钥的字典
    [queryPrivateKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPrivateKey setObject:privateTag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPrivateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [queryPrivateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];

    // 2 从钥匙串中找到私钥
    status = SecItemCopyMatching
    ((__bridge CFDictionaryRef)queryPrivateKey, (CFTypeRef *)&privateKey);

    //  Allocate the buffer
    plainBufferSize = SecKeyGetBlockSize(privateKey);
    plainBuffer = malloc(plainBufferSize);

    if (plainBufferSize < cipherBufferSize) {
        // Ordinarily, you would split the data up into blocks
        // equal to plainBufferSize, with the last block being
        // shorter. For simplicity, this example assumes that
        // the data is short enough to fit.
        printf("Could not decrypt.  Packet too large.\n");
        return;
    }

   // 3 解密数据
    status = SecKeyDecrypt(privateKey,
                           kSecPaddingPKCS1,
                           cipherBuffer,
                           cipherBufferSize,
                           plainBuffer,
                           &plainBufferSize
                           );
    NSData *key = [NSData dataWithBytes:(const void*)plainBuffer length:(NSUInteger)plainBufferSize];
    
    NSString *res = [[NSString alloc] initWithData:key encoding:NSUTF8StringEncoding];
    
    SLog(@"解密数据： %@", res);
    // 4 释放内存
    if(privateKey) CFRelease(privateKey);
}

@end


