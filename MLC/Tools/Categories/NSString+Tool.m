//
//  NSString+Tool.m
//  HGSWB
//
//  Created by 黄刚 on 2018/11/6.
//  Copyright © 2018 HuangGang'sMac. All rights reserved.
//

#import "NSString+Tool.h"
#import <objc/runtime.h>

static const void *nameKey = &nameKey;

@implementation NSString (Tool)


- (void)setName:(NSString *)name {
    
    
   /**
    *  根据某个对象，还有key，还有对应的策略(copy,strong等) 动态的将值设置到这个对象的key上
    *
    *  @param object 某个对象
    *  @param key    属性名,根据key去获取关联的对象, 是一个字符串常量，是一个地址(这里注意，地址必须是不变的，地址不同但是内容相同的也不算同一个key)
    *  @param value  要设置的值
    *  @param policy 策略(copy,strong，assign等)
    */
    objc_setAssociatedObject(self, &nameKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)name {
    return objc_getAssociatedObject(self, nameKey);
}



+ (NSData *) switchToDataForURLString:(NSString *) urlStr{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data;
}

@end
