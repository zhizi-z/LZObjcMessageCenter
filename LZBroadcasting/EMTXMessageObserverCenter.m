//
//  EMTXMessageObserverCenter.m
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/4/24.
//  Copyright © 2019 zlh. All rights reserved.
//

#import "EMTXMessageObserverCenter.h"

@interface EMTXMessage()

@property (nonatomic, copy) EMTXMessageName name;//消息名称
@property (nonatomic, strong) id object;//正常情况下为消息发送者,具体值以调用方传递值为准
@property (nonatomic, strong) EMTXMessageInfo userInfo;//携带参数
@property (nonatomic, weak) id observer;
@property (nonatomic, assign) SEL selector;
//handler和selector,不可能同时使用
@property (nonatomic, copy) void(^handler)(EMTXMessage *);

@end

@implementation EMTXMessage

@end

@interface EMTXMessageObserverCenter()

@property (nonatomic, strong) NSMutableDictionary <EMTXMessageName, NSMutableArray<EMTXMessage *> *> *dicObservers;

@end

@implementation EMTXMessageObserverCenter

+ (instancetype)defaultCenter
{
    static dispatch_once_t onceToken;
    static EMTXMessageObserverCenter *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

+ (instancetype)smallCenter
{
    return [[self alloc] init];
}

- (instancetype)init
{
    if (self = [super init])
    {
        _dicObservers = [NSMutableDictionary new];
    }
    return self;
}

//在observer里添加一个语句块aHandler,收到aName消息后,执行该语句块aHandler
- (void)addObserver:(id)observer execution:(void(^)(EMTXMessage *))aHandler name:(EMTXMessageName)aName
{
    NSMutableArray *observers = [self.dicObservers objectForKey:aName];
    if (observers == nil)
    {
        observers = [NSMutableArray new];
        [self.dicObservers setObject:observers forKey:aName];
    }
    
    __block BOOL isContained = NO;
    [[observers copy] enumerateObjectsUsingBlock:^(EMTXMessage *  _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
        if (message.observer == nil)
        {
            [observers removeObject:message];
        }
        else if (!isContained && [message.observer isEqual:observer] && [message.handler isEqual:aHandler])
        {
            isContained = YES;;
        }
    }];
    if (isContained) return;
    
    EMTXMessage *newMsg = [EMTXMessage new];
    newMsg.observer = observer;
    newMsg.handler = aHandler;
    [observers addObject:newMsg];
}

//添加一个observer去侦听aName消息,收到消息后执行aSelector
- (void)addObserver:(id)observer selector:(SEL)aSelector name:(EMTXMessageName)aName
{
    NSMutableArray *observers = [self.dicObservers objectForKey:aName];
    if (observers == nil)
    {
        observers = [NSMutableArray new];
        [self.dicObservers setObject:observers forKey:aName];
    }

    __block BOOL isContained = NO;
    [[observers copy] enumerateObjectsUsingBlock:^(EMTXMessage *  _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
        if (message.observer == nil)
        {
            [observers removeObject:message];
        }
        else if (!isContained && [message.observer isEqual:observer] && (message.selector == aSelector))
        {
            isContained = YES;;
        }
    }];
    if (isContained) return;
    
    EMTXMessage *newMsg = [EMTXMessage new];
    newMsg.observer = observer;
    newMsg.selector = aSelector;
    [observers addObject:newMsg];
}

//发送一个aName消息,并携带aUserInfo作为消息方法执行参数,anObject可选
- (void)postMessageName:(EMTXMessageName)aName userInfo:(nullable EMTXMessageInfo)aUserInfo object:(nullable id)anObject
{
    NSMutableArray *observers = [self.dicObservers objectForKey:aName];
    if (observers == nil) return;
    [[observers copy] enumerateObjectsUsingBlock:^(EMTXMessage *  _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
        if (message.observer == nil)
        {
            [observers removeObject:message];
            return;
        }
        if (message.selector != NULL && [message.observer respondsToSelector:message.selector])
        {
            IMP imp = [message.observer methodForSelector:message.selector];
            void (*func) (id, SEL, id) = (void *)imp;
            EMTXMessage *newMsg = [EMTXMessage new];
            newMsg.userInfo = aUserInfo;
            newMsg.name = aName;
            newMsg.object = anObject;
            func(message.observer, message.selector, newMsg);
        }
        if (message.handler != NULL)
        {
            EMTXMessage *newMsg = [EMTXMessage new];
            newMsg.userInfo = aUserInfo;
            newMsg.name = aName;
            newMsg.object = anObject;
            message.handler(newMsg);
        }
    }];
}

//移除observer侦听的所有消息
- (void)removeObserver:(id)observer
{
    NSArray *allObservers = [self.dicObservers allValues];
    [allObservers enumerateObjectsUsingBlock:^(NSMutableArray *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[obj copy] enumerateObjectsUsingBlock:^(EMTXMessage *  _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([message.observer isEqual:observer])
            {
                [obj removeObject:message];
            }
        }];
    }];
}

//移除observer侦听的aName消息
- (void)removeObserver:(id)observer name:(EMTXMessageName)aName
{
    NSMutableArray *observers = [self.dicObservers objectForKey:aName];
    [[observers copy] enumerateObjectsUsingBlock:^(EMTXMessage *  _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([message.observer isEqual:observer])
        {
            [observers removeObject:message];
        }
    }];
}

@end
