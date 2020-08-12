//
//  NSObject+HGKVO.m
//  HGSWB
//
//  Created by 黄刚 on 2019/9/27.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "NSObject+HGKVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSString *const HGKVOClassPrefix = @"HGKVOPrefix_";
NSString *const HGKVOAssociatedObservers = @"HGKVOAssociatedObservers";

//#import <AppKit/AppKit.h>

#pragma mark -- PGObservationInfo
@interface PGObservationInfo : NSObject

@property(nonatomic, weak) NSObject *observer;
@property(nonatomic, copy) NSString *key;
@property(nonatomic, copy) PGObservingBlock block;

@end

@implementation PGObservationInfo

- (instancetype)initWithObserver:(NSObject *)observer key:(NSString *)key block:(PGObservingBlock)block {
    self = [super self];
    if (self) {
        _observer = observer;
        _key = key;
        _block = block;
    }
    
    return self;
}

@end



#pragma mark -- Helpers
static NSString *getterForSetter(NSString *setter) {
    
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {//hasSuffix
        return nil;
    }
    
    //remove 'set' at the begining and ':' at the end
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    
    //lower case the first letter
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetter];
    
    return key;
}


//得到set+属性名的方法名称
static NSString *setterForGetter(NSString *getter) {
   
    if (getter.length <= 0) {
        return  nil;
    }
    
    //upper case the first letter
    //substringToIndex 截取字符串到第一个， uppercaseString 大写
    NSString *firstLetter = [[getter substringToIndex:1] uppercaseString];
    //返回一个字符串，这个字符串截取范围是给定索引index到这个字符串的结尾
    NSString *remainingLetters = [getter substringFromIndex:1];
    
    //add 'set' at the begining and ':' at the end
    //要求set后的第一个首字母大写
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", firstLetter, remainingLetters];
    
    return setter;
    
}



#pragma mark -- Overridden Methods
//?? SEL _cmd 什么用
static void kvo_setter(id self, SEL _cmd, id newValue) {
    
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterForSetter(setterName);
                           
    if (!getterName) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have setter %@", self, setterName];
        
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
        
        return;
    }
    
    id oldValue = [self valueForKey:getterName];
    struct objc_super supperclazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self)) //传递父类的指针
    };
    
    
    //cast our pointer so the compiler won't complain
    //?? why
    //消息转发
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void*)objc_msgSendSuper;
    
    //call super's setter, which is original class's setter method
    //消息转发
    objc_msgSendSuperCasted(&supperclazz, _cmd, newValue);
    
    //look up observers and call the blocks
    //?? objc_getAssociatedObject
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge  const void *)(HGKVOAssociatedObservers));
    for (PGObservationInfo *each in observers) {
        if ([each.key isEqualToString:getterName]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                each.block(self, getterName, oldValue, newValue);
            });
        }
    }
}

//返回 Class 类型
static Class kvo_class(id self, SEL _cmd) {
    return  class_getSuperclass(object_getClass(self));
}






@implementation NSObject (HGKVO)

- (void)PG_addObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(PGObservingBlock)block {
    
    //??
    SEL setterSelector = NSSelectorFromString(setterForGetter(key));
    //class_getInstanceMethod 得到类的实例方法
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    if (!setterMethod) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have a setter for key %@", self, key];
        
        /*一般处理方式
         a.app异常闪退，那么捕获crash信息，并记录在本地沙盒中。
         b.当下次用户重新打开app的时候，检查沙盒中是否保存有上次捕获到的crash信息。
         c.如果有那么利用专门的接口发送给服务器，以求在后期版本中修复。
         
         如果没有则抛出异常
           exceptionWithName:异常的名称
           reason:异常的原因
           userInfo:异常的信息
        **/
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];//NSInvalidArgumentException 参数传递问题
        return;
    }
    
    //返回self的isa所指向的类
    Class clazz = object_getClass(self);
    NSString *clazzName = NSStringFromClass(clazz);
    
    //if not an KVO class yet 动态生成子类
    if (![clazzName hasPrefix:HGKVOClassPrefix]) {//返回一个布尔值表示字符串是否以指定的前缀开始
        clazz = [self makeKvoClassWithOriginalClassName:clazzName];
        //替换类，isa指针指向了clazz
        object_setClass(self, clazz);
    }
    
    
    //add our kvo setter if this class (not superclasses) doesn't implement the setter?
    //添加set方法 set
    if (![self hasSelector:setterSelector]) {
        const char *types = method_getTypeEncoding(setterMethod);//?? method_getTypeEncoding 什么用
        class_addMethod(clazz, setterSelector, (IMP)kvo_setter, types);
    }
    
    PGObservationInfo *info = [[PGObservationInfo alloc] initWithObserver:observer key:key block:block];
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(HGKVOAssociatedObservers));
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void *)(HGKVOAssociatedObservers), observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [observers addObject:info];
    
}

- (void)PG_removeObserver:(NSObject *)observer forKey:(NSString *)key {
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(HGKVOAssociatedObservers));
    
    PGObservationInfo *infoToRemove;
    for (PGObservationInfo *info in observers) {
        if (info.observer == observer && [info.key isEqual:key]) {
            infoToRemove = info;
            break;
        }
    }
    
    [observers removeObject:infoToRemove];
}


- (BOOL) hasSelector:(SEL)selector {
    
    Class clazz = object_getClass(self);
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(clazz, &methodCount);
    
    for (unsigned int i = 0; i < methodCount; i ++) {
        SEL thisSelector = method_getName(methodList[i]);
        if (thisSelector == selector) {
            free(methodList);//?? 为什么释放， SEL 是一个指针
            return YES;
        }
    }
    
    free(methodList);
    return NO;
    
}

//创建子类
- (Class) makeKvoClassWithOriginalClassName:(NSString *)originalClazzName {
    
    //子类的名字
    NSString *kvoClazzName = [HGKVOClassPrefix stringByAppendingString:originalClazzName];
    Class clazz = NSClassFromString(kvoClazzName);
    //是否有这个新类
    if (clazz) {
        return  clazz;
    }
    
    //class doesn't exist yet, make it  动态生成子类
    Class originalClazz = object_getClass(self);
    //objc_allocateClassPair 创建一个新类或者元类，元类第一个参数为nil
    Class kvoClazz = objc_allocateClassPair(originalClazz, kvoClazzName.UTF8String, 0);//第一个参数 父类名，第二个参数 新类名字，第三个参数 新类占用的空间
    
    //grab grab class method's signature so we can borrow it
    //注册
    //添加class的方法
    Method clazzMethod = class_getInstanceMethod(originalClazz, @selector(class));  //获取实例方法
    const char *types = method_getTypeEncoding(clazzMethod);    //使用@encode将消息编码成字符串形式
    /*
     添加方法
     SEL 方法选择器，方法编号，类似于函数指针也就是方法函数指针，这个可以随便填，但是方法的格式一定要和你需要添加的方法的格式一样，比如有无参数
     IMP： implementation 指针指向函数的实现
     types： 代表一些返回值，参数等等
     */
    class_addMethod(kvoClazz, @selector(class), (IMP)kvo_class, types);
    
    //注册一个类
    objc_registerClassPair(kvoClazz);
    
    return kvoClazz;
    
}


@end
