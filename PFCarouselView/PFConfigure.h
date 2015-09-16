//
//  PFConfigure.h
//  PFConfigure
//
//  Created by PFei_He on 15/9/16.
//  Copyright (c) 2015年 PF-Lib. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#ifndef PFConfigure_PFConfigure_h
#define PFConfigure_PFConfigure_h

#pragma mark - COMMON
/*=================================================
 通用
 =================================================*/

#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue])

#pragma mark - AUTOMATION
/*=================================================
 通知
 =================================================*/
/**
 *  添加通知的监听者
 *  参数：
 *  __name__:               方法名
 *  __class__:              所在的类的类名
 *  __notification_name__:  通知名
 *
 *  示例：
 *  kOBSERVER(noti, Configure, PFConfigureNotification)
 */
#define kOBSERVER(__name__, __class__, __notification_name__)\
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(__name__##At##__class__##Notification:) name:__notification_name__ object:nil];

/**
 *  添加通知的监听者
 *  参数：
 *  __name__:           方法名
 *  __class__:          所在的类的类名
 *  __notification__:   通知的对象
 *  __statement__:      通知方法执行的代码（建议只执行简单代码）
 *
 *  示例：
 *  kNOTIFICATION2(noti, Configure, notification, do something simple...)
 */
#define kNOTIFICATION1(__name__, __class__, __notification__, __statement__)\
- (void)__name__##At##__class__##Notification:(NSNotification *)__notification__\
{\
    __statement__;\
}

/**
 *  添加通知的方法
 *  参数：
 *  __name__:           方法名
 *  __class__:          所在的类的类名
 *  __notification__:   通知的对象
 *
 *  示例：
 *  kNOTIFICATION2(noti, Configure, notification)
 *  {
 *      do something...
 *  }
 */
#define kNOTIFICATION2(__name__, __class__, __notification__)\
- (void)__name__##At##__class__##Notification:(NSNotification *)__notification__

/*=================================================
 代码块方法
 =================================================*/
/**
 *  自动生成.m文件的代码块方法
 *  参数：
 *  __name__:       方法名
 *  __returned__:   返回值
 *  __class__:      需要传递的参数的类名
 *  __block__:      接收的代码块
 *  __statement__:  代码块方法执行的代码（建议只执行简单代码）
 *
 *  示例：
 *  kBLOCK1(name, void, NSString *, b, do something...)
 */
#define kBLOCK1(__name__, __returned__, __class__, __block__, __statement__)\
- (void)__name__##UsingBlock:(__returned__ (^)(__class__))block\
{\
    __block__ = block;\
    __statement__;\
}

/**
 *  自动生成.m文件的代码块方法
 *  参数：
 *  __name__:       方法名
 *  __returned__:   返回值
 *  __class1__:     需要传递的参数的类名
 *  __class2__:     需要传递的参数的类名
 *  __block__:      接收的代码块
 *  __statement__:  代码块方法执行的代码（建议只执行简单代码）
 *
 *  示例：
 *  kBLOCK2(name, void, NSString *, NSString*, b, do something...)
 */
#define kBLOCK2(__name__, __returned__, __class1__, __class2__, __block__, __statement__)\
- (void)__name__##UsingBlock:(__returned__ (^)(__class1__, __class2__))block\
{\
    __block__ = block;\
    __statement__;\
}

/**
 *  自动生成.m文件的代码块方法
 *  参数：
 *  __name__:       方法名
 *  __at__:         所在的类的类名
 *  __returned__:   返回值
 *  __class__:      需要传递的参数的类名
 *  __block__:      接收的代码块
 *  __statement__:  代码块方法执行的代码（建议只执行简单代码）
 *
 *  示例：
 *  kBLOCK3(name, Configure, void, NSString *, NSString*, b, do something...)
 */
#define kBLOCK3(__name__, __at__, __class__, __block__, __statement__)\
- (void)__name__##At##__at__##UsingBlock:(__returned__ (^)(__class__))block\
{\
    __block__ = block;\
    __statement__;\
}

/**
 *  自动生成.m文件的代码块方法
 *  参数：
 *  __name__:       方法名
 *  __at__:         所在的类的类名
 *  __returned__:   返回值
 *  __class1__:     需要传递的参数的类名
 *  __class2__:     需要传递的参数的类名
 *  __block__:      接收的代码块
 *  __statement__:  代码块方法执行的代码（建议只执行简单代码）
 *
 *  示例：
 *  kBLOCK2(do, Configure, void, NSString *, NSString *, b, do something...)
 */
#define kBLOCK4(__name__, __at__, __class1__, __class2__, __block__, __statement__)\
- (void)__name__##At##__at__##UsingBlock:(__returned__ (^)(__class1__, __class2__))block\
{\
    __block__ = block;\
    __statement__;\
}

/*=================================================
 监听代理的回调或代码块的回调
 =================================================*/
/**
 *  自动生成代理或代码块的监听回调
 *  参数：
 *  __delegate_method__:    代理方法名
 *  __args__:               需要传递的参数（一般为'self'）
 *  __block__:              接收的代码块
 *
 *  示例：
 *  情况一：无参数
 *  kCALLBACK1(m, nil, b)
 *
 *  情况二：一个参数
 *  kCALLBACK1(m:, a, b)
 */
#define kCALLBACK1(__delegate_method__, __args__, __block__)\
if ([self.delegate respondsToSelector:@selector(__delegate_method__)]) {\
    [self.delegate __delegate_method__(__args__)];\
} else if (__block__) {\
    __block__(__args__);\
}

/**
 *  自动生成代理或代码块的监听回调
 *  参数：
 *  __delegate_method_section1__:   代理方法的第一部分（第一个冒号前的内容，包括冒号）
 *  __args1__:                      需要传递的参数（一般为`self`）
 *  __delegate_method_section2__:   代理方法的第二部分（第二个冒号前的内容，包括冒号）
 *  __args2__:                      需要传递的参数
 *  __block__:                      接收的代码块
 *
 *  示例：
 *  kCALLBACK2(s1:, self, s2:, a2, b)
 */
#define kCALLBACK2(__delegate_method_section1__, __args1__, __delegate_method_section2__, __args2__, __block__)\
if ([self.delegate respondsToSelector:@selector(__delegate_method_section1__ __delegate_method_section2__)]) {\
    [self.delegate __delegate_method_section1__(__args1__)__delegate_method_section2__(__args2__)];\
} else if (__block__) {\
    __block__(__args2__);\
}

/**
 *  自动生成代理或代码块的监听回调
 *  参数：
 *  __delegate_method_section1__:   代理方法的第一部分（第一个冒号前的内容，包括冒号）
 *  __args1__:                      需要传递的参数（一般为`self`）
 *  __delegate_method_section2__:   代理方法的第二部分（第二个冒号前的内容，包括冒号）
 *  __args2__:                      需要传递的参数
 *  __delegate_method_section3__:   代理方法的第三部分（第三个冒号前的内容，包括冒号）
 *  __args3__:                      需要传递的参数
 *  __block__:                      接收的代码块
 *
 *  示例：
 *  kCALLBACK2(s1:, self, s2:, a2, s3:, a3, b)
 */
#define kCALLBACK3(__delegate_method_section1__, __args1__, __delegate_method_section2__, __args2__, __delegate_method_section3__, __args3__, __block__)\
if ([self.delegate respondsToSelector:@selector(__delegate_method_section1__ __delegate_method_section2__ __delegate_method_section3__)]) {\
    [self.delegate __delegate_method_section1__(__args1__)__delegate_method_section2__(__args2__)__delegate_method_section3__(__args3__)];\
} else if (__block__) {\
    __block__(__args2__, __args3__);\
}

#pragma mark - TRANSFORMATION
/*=================================================
 强弱引用转换
 =================================================*/
/**
 *  强弱引用转换，用于解决代码块（block）与强引用self之间的循环引用问题
 *  调用方式: `@weakify_self`实现弱引用转换，`@strongify_self`实现强引用转换
 *
 *  示例：
 *  @weakify_self
 *  [obj block:^{
 *      @strongify_self
 *      self.property = something;
 *  }];
 */
#ifndef	weakify_self
#if __has_feature(objc_arc)
        #define weakify_self autoreleasepool{} __weak __typeof__(self) weakSelf = self;
    #else
        #define weakify_self autoreleasepool{} __block __typeof__(self) blockSelf = self;
    #endif
#endif
#ifndef	strongify_self
    #if __has_feature(objc_arc)
        #define strongify_self try{} @finally{} __typeof__(weakSelf) self = weakSelf;
    #else
        #define strongify_self try{} @finally{} __typeof__(blockSelf) self = blockSelf;
    #endif
#endif

/**
 *  强弱引用转换，用于解决代码块（block）与强引用对象之间的循环引用问题
 *  调用方式: `@weakify(object)`实现弱引用转换，`@strongify(object)`实现强引用转换
 *
 *  示例：
 *  @weakify(object)
 *  [obj block:^{
 *      @strongify(object)
 *      strong_object = something;
 *  }];
 */
#ifndef	weakify
#if __has_feature(objc_arc)
        #define weakify(object)	autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
    #else
        #define weakify(object)	autoreleasepool{} __block __typeof__(object) block##_##object = object;
    #endif
#endif
#ifndef	strongify
    #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) strong##_##object = weak##_##object;
    #else
        #define strongify(object) try{} @finally{} __typeof__(object) strong##_##object = block##_##object;
    #endif
#endif

#endif
