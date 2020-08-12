//
//  NSObject+HGKVO.h
//  HGSWB
//
//  Created by 黄刚 on 2019/9/27.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

//#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PGObservingBlock)(id observedObject, NSString *observedKey, id oldValue, id newValue);



@interface NSObject (HGKVO)


- (void) PG_addObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(PGObservingBlock)block;

- (void) PG_removeObserver:(NSObject *)observer forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
