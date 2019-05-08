//
//  NSObject+EMTXRouter.h
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/4/26.
//  Copyright © 2019 zlh. All rights reserved.
//

//#import "EMTXRouterPack.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString * EMTXPackName;
typedef NSNumber * EMTXPackPostFlag;//@(0)/nil => 停止; @(1) => 向下发送(返回); @(2),其他 => 向上发送
typedef NSDictionary * EMTXPackInfo;//发送包所需携带信息


@class EMTXPackAction;


@interface EMTXRouterPack : NSObject

@property (nonatomic, copy, readonly) EMTXPackName name;//包名
@property (nonatomic, weak, readonly) id source;//发送方
@property (nonatomic, weak, readonly) id target;//接收方,返回时才会被赋值
@property (nonatomic, assign, readonly) BOOL isOutGoing;//发送、返回标志 YES=发送;NO=返回;
@property (nonatomic, copy, readonly) void(^callBack)(EMTXRouterPack *pack);//target可直接回调source的callBack
@property (nonatomic, strong) EMTXPackInfo userInfo;//携带参数,可自行设定(一般用在返回时设定)

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (EMTXRouterPack *)packWithName:(EMTXPackName)aName source:(nullable id)aSource callBack:(nullable void(^)(EMTXRouterPack *))aCallBack userInfo:(nullable EMTXPackInfo)aUserInfo;

@end


@interface NSObject (EMTXRouter)

- (void)addNextNode:(id)nextNode;//如果当前是UIResponder对象,则nextNode默认nextResponder, 否则为nil
- (void)removeNextNode;//若您调用了addNextNode:,就一定要在调dealloc前调用removeNextNode

- (void)setPostFlag:(EMTXPackPostFlag)flag forPack:(EMTXPackName)aPack;//为每个包设定方向,默认传递到当前处理对象停止

//收到名为aName的包时,执行语句块aHandler
- (void)subscribePackName:(EMTXPackName)aName execution:(void(^)(EMTXRouterPack *))aHandler;
//收到名为aName的包时,执行方法aSelector
- (void)subscribePackName:(EMTXPackName)aName selector:(SEL)aSelector;
//向上层发送名为aName的包
- (void)postPack:(EMTXRouterPack *)aPack;
//取消订阅所有的包
- (void)unSubscribePacks;
//取消订阅名为aName的包
- (void)unSubscribePack:(EMTXPackName)aName;

@end

NS_ASSUME_NONNULL_END
