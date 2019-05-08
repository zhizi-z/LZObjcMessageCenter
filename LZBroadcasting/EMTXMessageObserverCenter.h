//
//  EMTXMessageObserverCenter.h
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/4/24.
//  Copyright © 2019 zlh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * EMTXMessageName;
typedef NSDictionary * EMTXMessageInfo;

@interface EMTXMessage : NSObject

@property (nonatomic, copy, readonly) EMTXMessageName name;//消息名称
@property (nonatomic, strong, readonly) id object;//正常情况下为消息发送者,具体值以调用方传递值为准
@property (nonatomic, strong, readonly) EMTXMessageInfo userInfo;//携带参数

@end

@interface EMTXMessageObserverCenter : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

//公共消息中心,单例,每次调用都返回相同的对象
+ (instancetype)defaultCenter;
//小范围消息中心,返回一个新的实例对象,每次调用返回不同的对象
+ (instancetype)smallCenter;
//在observer里添加一个语句块aHandler,收到aName消息后,执行该语句块aHandler
- (void)addObserver:(id)observer execution:(void(^)(EMTXMessage *))aHandler name:(EMTXMessageName)aName;
//添加一个observer去侦听aName消息,收到消息后执行aSelector
- (void)addObserver:(id)observer selector:(SEL)aSelector name:(EMTXMessageName)aName;
//发送一个aName消息,并携带aUserInfo作为消息方法执行参数,anObject可选
- (void)postMessageName:(EMTXMessageName)aName userInfo:(nullable EMTXMessageInfo)aUserInfo object:(nullable id)anObject;
//移除observer侦听的所有消息
- (void)removeObserver:(id)observer;
//移除observer侦听的来自anOjbect的aName消息
- (void)removeObserver:(id)observer name:(EMTXMessageName)aName;

@end

NS_ASSUME_NONNULL_END
