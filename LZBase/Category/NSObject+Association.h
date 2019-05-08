//
//  NSObject+Association.h
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/4/26.
//  Copyright © 2019 zlh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Association)

- (id)associatedObjectForProperty:(NSString *)propertyName;
- (void)associateObject:(id)value forProperty:(NSString *)propertyName;

@end

NS_ASSUME_NONNULL_END
