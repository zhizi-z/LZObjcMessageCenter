//
//  NSObject+EMTXMessageRouter.m
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/4/26.
//  Copyright © 2019 zlh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+EMTXRouter.h"
#import "NSObject+Association.h"

@interface EMTXPackAction : NSObject

@property (nonatomic, assign) SEL selector;
//handler和selector,不可能同时使用
@property (nonatomic, copy) void(^handler)(EMTXRouterPack *);

@end

@implementation EMTXPackAction

@end


@interface EMTXRouterPack()

@property (nonatomic, copy) EMTXPackName name;//包名
@property (nonatomic, weak) id source;//发送方
@property (nonatomic, weak) id target;//接收方,返回时才会被赋值
@property (nonatomic, weak) id current;//当前处理方
@property (nonatomic, assign) BOOL isOutGoing;//发送、返回标志 YES=发送;NO=返回;
@property (nonatomic, copy) void(^callBack)(EMTXRouterPack *pack);//target可直接回调source的callBack

@end

@implementation EMTXRouterPack

+ (EMTXRouterPack *)packWithName:(NSString *)aName source:(nullable id)aSource callBack:(nullable void(^)(EMTXRouterPack *))aCallBack userInfo:(nullable EMTXPackInfo)aUserInfo
{
    EMTXRouterPack *pack = [[self alloc] init];
    pack.name = aName;
    pack.source = aSource;
    pack.isOutGoing = YES;
    pack.callBack = aCallBack;
    pack.userInfo = aUserInfo;
    return pack;
}
@end


@interface NSObject (EMTXRouterExtention)

@property (nonatomic, weak) id lastNode;//只有当包被传送到当前对象时,才会赋值
@property (nullable, nonatomic, strong) id nextNode;//如果当前是UIResponder对象,则该值默认nextResponder, 否则为nil
@property (nonatomic, strong) NSMutableDictionary<EMTXPackName, EMTXPackPostFlag> *dicPostFlag;//用户需为每个包设定方向,不设置则默认向上传递
@property (nonatomic, strong) NSMutableDictionary<EMTXPackName, NSMutableArray<EMTXPackAction *> *> *dicPackActions;//所有注册过的包处理

@end

@implementation NSObject (EMTXRouterExtention)

- (id)lastNode
{
    return [self associatedObjectForProperty:@"lastNode"];
}

- (void)setLastNode:(id)nextNode
{
    [self associateObject:nextNode forProperty:@"lastNode"];
}

- (id)nextNode
{
    return [self associatedObjectForProperty:@"nextNode"];
}

- (void)setNextNode:(id)nextNode
{
    [self associateObject:nextNode forProperty:@"nextNode"];
}

- (NSMutableDictionary *)dicPostFlag
{
    NSMutableDictionary *dicPostFlag = [self associatedObjectForProperty:@"dicPostFlag"];
    if (dicPostFlag == nil)
    {
        dicPostFlag = [NSMutableDictionary new];
        [self associateObject:dicPostFlag forProperty:@"dicPostFlag"];
    }
    return dicPostFlag;
}

- (void)setDicPostFlag:(NSMutableDictionary *)dicPostFlag
{
    [self associateObject:dicPostFlag forProperty:@"dicPostFlag"];
}

- (NSMutableDictionary *)dicPackActions
{
    NSMutableDictionary *dicPackActions = [self associatedObjectForProperty:@"dicPackActions"];
    if (dicPackActions == nil)
    {
        dicPackActions = [NSMutableDictionary new];
        [self associateObject:dicPackActions forProperty:@"dicPackActions"];
    }
    return dicPackActions;
}

- (void)setDicPackActions:(NSMutableDictionary *)dicPackActions
{
    [self associateObject:dicPackActions forProperty:@"dicPackActions"];
}

@end


@implementation NSObject (EMTXRouter)

//收到名为aName的包时,执行语句块aHandler
- (void)subscribePackName:(EMTXPackName)aName execution:(void(^)(EMTXRouterPack *))aHandler
{
    NSMutableArray *actions = [self.dicPackActions objectForKey:aName];
    if (actions == nil)
    {
        actions = [NSMutableArray new];
        [self.dicPackActions setObject:actions forKey:aName];
    }
    
    __block BOOL isContained = NO;
    [[actions copy] enumerateObjectsUsingBlock:^(EMTXPackAction *  _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!isContained && [action.handler isEqual:aHandler])
        {
            isContained = YES;;
        }
    }];
    if (isContained) return;
    
    EMTXPackAction *action = [EMTXPackAction new];
    action.handler = aHandler;
    [actions addObject:action];
}

//收到名为aName的包时,执行方法aSelector
- (void)subscribePackName:(EMTXPackName)aName selector:(SEL)aSelector
{
    NSMutableArray *actions = [self.dicPackActions objectForKey:aName];
    if (actions == nil)
    {
        actions = [NSMutableArray new];
        [self.dicPackActions setObject:actions forKey:aName];
    }

    __block BOOL isContained = NO;
    [[actions copy] enumerateObjectsUsingBlock:^(EMTXPackAction *  _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!isContained && (action.selector == aSelector))
        {
            isContained = YES;;
        }
    }];
    if (isContained) return;
    
    EMTXPackAction *action = [EMTXPackAction new];
    action.selector = aSelector;
    [actions addObject:action];
}

//向上层发送名为aName的包
- (void)postPack:(EMTXRouterPack *)aPack
{
    if(aPack.name.length == 0)
        return;
    BOOL usingNextResponder = NO;
    if (aPack.isOutGoing)
    {
        self.lastNode = aPack.current;
        aPack.current = self;
        
        if (self.nextNode == nil && [self isKindOfClass:[UIResponder class]])
        {
            self.nextNode = ((UIResponder *)self).nextResponder;
            usingNextResponder = YES;
        }
    }
    
    NSMutableArray *actions = [self.dicPackActions objectForKey:aPack.name];
    if (actions.count == 0)
    {
        id nextExecutionObject = aPack.isOutGoing ? self.nextNode : self.lastNode;
        [nextExecutionObject postPack:aPack];
    }
    else {
        [[actions copy] enumerateObjectsUsingBlock:^(EMTXPackAction *  _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
            if (action.selector != NULL && [self respondsToSelector:action.selector])
            {
                IMP imp = [self methodForSelector:action.selector];
                void (*func) (id, SEL, id) = (void *)imp;
                func(self, action.selector, aPack);
            }
            if (action.handler != NULL)
            {
                action.handler(aPack);
            }
        }];
        
        if (!aPack.isOutGoing)
        {
            [self.lastNode postPack:aPack];
        }
        else {
            if (self.dicPostFlag[aPack.name] && self.dicPostFlag[aPack.name].integerValue != 0)
            {
                id nextExecutionObject = self.nextNode;
                if (self.dicPostFlag[aPack.name].integerValue == 1)
                {//返回
                    nextExecutionObject = self.lastNode;
                    aPack.target = self;
                    aPack.isOutGoing = NO;
                }
                [nextExecutionObject postPack:aPack];
            }
        }
    }
    
    if (usingNextResponder)
    {
        self.nextNode = nil;
    }
}

//取消订阅所有的包
- (void)unSubscribePacks
{
    [self.dicPackActions removeAllObjects];
}

//取消订阅名为aName的包
- (void)unSubscribePack:(EMTXPackName)aName
{
    [self.dicPackActions removeObjectForKey:aName];
}

- (void)addNextNode:(id)nextNode
{
    self.nextNode = nextNode;
}

- (void)removeNextNode
{
    self.nextNode = nil;
}

- (void)setPostFlag:(EMTXPackPostFlag)flag forPack:(EMTXPackName)aPack
{
    [self.dicPostFlag setObject:flag forKey:aPack];
}

@end
