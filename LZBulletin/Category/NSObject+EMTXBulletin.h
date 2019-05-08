//
//  NSObject+EMTXBulletin.h
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/5/7.
//  Copyright © 2019 zlh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * EMTXBulletinTitle;
typedef NSDictionary * EMTXBulletinInfo;


@interface EMTXBulletinBoard : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)defaultBoard;
- (void)erase;

@end


@interface EMTXBulletin : NSObject

@property (nonatomic, copy, readonly) EMTXBulletinTitle name;//公告名称
@property (nonatomic, weak, readonly) id object;//公告发布者
@property (nonatomic, strong, readonly) EMTXBulletinInfo userInfo;//携带参数

@end


@interface NSObject (EMTXBulletin)

//发布一个aName公告,并携带aUserInfo作为公告内容,anObject可选(比如:公告发布者)
//同一个对象发布与之前相同标题的公告,需先擦除之前的公告,否则不能覆盖
//发布了公告,需要在恰当的时候手动移除公告,否则内存中可能会存在多个同标题不同对象的公告
- (void)writeBulletin:(EMTXBulletinTitle)aName userInfo:(nullable EMTXBulletinInfo)aUserInfo object:(nullable id)anObject;
//去公告板查看aName公告,执行aHandler
- (void)readBulletinName:(EMTXBulletinTitle)aName execution:(void(^)(EMTXBulletin *))aHandler;
//去公告板查看aName公告,执行aSelector
- (void)readBulletinName:(EMTXBulletinTitle)aName selector:(SEL)aSelector;
//擦除特定对象发布的某一公告,anObject==nil时则擦除名为aName的所有公告
- (void)eraseBulletin:(EMTXBulletinTitle)aName object:(nullable id)anObject;

@end

NS_ASSUME_NONNULL_END
