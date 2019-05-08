//
//  EMTXWeakRefTable.m
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/4/28.
//  Copyright © 2019 zlh. All rights reserved.
//

#import "EMTXWeakRefTable.h"

@interface EMTXWeakRefTable()

@property (nonatomic, strong) NSMapTable *weakTable;

@end

@implementation EMTXWeakRefTable

+ (instancetype)sharedInstance
{
    static EMTXWeakRefTable *weakContainer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weakContainer = [EMTXWeakRefTable new];
    });
    return weakContainer;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _weakTable = [NSMapTable weakToWeakObjectsMapTable];
    }
    return self;
}

- (void)setObject:(id)object forKey:(id)key
{
    [_weakTable setObject:object forKey:key];
}

- (id)objectForKey:(id)key
{
    return [_weakTable objectForKey:key];
}

@end
