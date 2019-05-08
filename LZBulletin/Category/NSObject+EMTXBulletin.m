//
//  NSObject+EMTXBulletin.m
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/5/7.
//  Copyright © 2019 zlh. All rights reserved.
//

#import "NSObject+EMTXBulletin.h"

@interface EMTXBulletinBoard()

@property (nonatomic, strong) NSMutableDictionary<EMTXBulletinTitle, NSMutableArray<EMTXBulletin *> *> *dicBulletins;//所有公告

@end

@implementation EMTXBulletinBoard

+ (instancetype)defaultBoard
{
    static dispatch_once_t onceToken;
    static EMTXBulletinBoard *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _dicBulletins = [NSMutableDictionary new];
    }
    return self;
}

- (void)erase
{
    [self.dicBulletins removeAllObjects];
}

@end


@interface EMTXBulletin()

@property (nonatomic, copy) EMTXBulletinTitle name;//公告名称
@property (nonatomic, weak) id object;//公告发布者
@property (nonatomic, strong) EMTXBulletinInfo userInfo;//携带参数

@end

@implementation EMTXBulletin

@end


@implementation NSObject (EMTXBulletin)

//发布一个aName公告,并携带aUserInfo作为公告内容,anObject可选(比如:公告发布者)
- (void)writeBulletin:(EMTXBulletinTitle)aName userInfo:(nullable EMTXBulletinInfo)aUserInfo object:(nullable id)anObject
{
    NSMutableArray *bulletins = [[EMTXBulletinBoard defaultBoard].dicBulletins objectForKey:aName];
    if (bulletins == nil)
    {
        bulletins = [NSMutableArray new];
        [[EMTXBulletinBoard defaultBoard].dicBulletins setObject:bulletins forKey:aName];
    }
    
    __block BOOL isContained = NO;
    [[bulletins copy] enumerateObjectsUsingBlock:^(EMTXBulletin *  _Nonnull bulletin, NSUInteger idx, BOOL * _Nonnull stop) {
        if (bulletin.object == nil)
        {
            [bulletins removeObject:bulletin];
        }
        else if (!isContained && [bulletin.object isEqual:anObject])
        {
            isContained = YES;;
        }
    }];
    if (isContained) return;
    
    EMTXBulletin *bulletin = [EMTXBulletin new];
    bulletin.name = aName;
    bulletin.userInfo = aUserInfo;
    bulletin.object = anObject;
    [bulletins addObject:bulletin];
}

//去公告板查看aName公告,执行aHandler
- (void)readBulletinName:(EMTXBulletinTitle)aName execution:(void(^)(EMTXBulletin *))aHandler
{
    NSMutableArray *bulletins = [[EMTXBulletinBoard defaultBoard].dicBulletins objectForKey:aName];
    [[bulletins copy] enumerateObjectsUsingBlock:^(EMTXBulletin *  _Nonnull bulletin, NSUInteger idx, BOOL * _Nonnull stop) {
        if (aHandler)
        {
            aHandler(bulletin);
        }
    }];
}

//去公告板查看aName公告,执行aSelector
- (void)readBulletinName:(EMTXBulletinTitle)aName selector:(SEL)aSelector
{
    NSMutableArray *bulletins = [[EMTXBulletinBoard defaultBoard].dicBulletins objectForKey:aName];
    [[bulletins copy] enumerateObjectsUsingBlock:^(EMTXBulletin *  _Nonnull bulletin, NSUInteger idx, BOOL * _Nonnull stop) {
        if (aSelector != NULL && [self respondsToSelector:aSelector])
        {
            IMP imp = [self methodForSelector:aSelector];
            void (*func) (id, SEL, id) = (void *)imp;
            func(self, aSelector, bulletin);
        }
    }];
}

//擦除特定对象发布的某一公告,anObject==nil时则擦除名为aName的所有公告
- (void)eraseBulletin:(EMTXBulletinTitle)aName object:(nullable id)anObject
{
    if (anObject == nil)
    {
        [[EMTXBulletinBoard defaultBoard].dicBulletins removeObjectForKey:aName];
    }
    else {
        NSMutableArray *bulletins = [[EMTXBulletinBoard defaultBoard].dicBulletins objectForKey:aName];
        [[bulletins copy] enumerateObjectsUsingBlock:^(EMTXBulletin *  _Nonnull bulletin, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([bulletin.object isEqual:anObject])
            {
                [bulletins removeObject:bulletin];
            }
        }];
    }
}

@end
