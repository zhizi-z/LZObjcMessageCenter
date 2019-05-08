//
//  EMTXWeakRefTable.h
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/4/28.
//  Copyright © 2019 zlh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMTXWeakRefTable : NSObject

+ (instancetype)sharedInstance;
- (void)setObject:(id)object forKey:(id)key;
- (id)objectForKey:(id)key;

@end

NS_ASSUME_NONNULL_END
