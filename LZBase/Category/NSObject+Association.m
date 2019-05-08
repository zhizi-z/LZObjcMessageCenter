//
//  NSObject+Association.m
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/4/26.
//  Copyright © 2019 zlh. All rights reserved.
//

#import "NSObject+Association.h"
#import "EMTXWeakRefTable.h"
#import <objc/runtime.h>

@implementation NSObject (Association)

- (id)associatedObjectForProperty:(NSString *)propertyName
{
    void *property;
    objc_AssociationPolicy associatedPolicy = [self associatedPolicyForProperty:propertyName outProperty:&property];
    if (associatedPolicy == OBJC_ASSOCIATION_ASSIGN && [[EMTXWeakRefTable sharedInstance] objectForKey:[NSString stringWithFormat:@"%@-%p", propertyName, property]] == nil)
    {//已释放
        objc_setAssociatedObject(self, property, nil, associatedPolicy);
    }
    return objc_getAssociatedObject(self, property);
}

- (void)associateObject:(id)value forProperty:(NSString *)propertyName
{
    void *property;
    objc_AssociationPolicy associatedPolicy = [self associatedPolicyForProperty:propertyName outProperty:&property];
    objc_setAssociatedObject(self, property, value, associatedPolicy);
    if (associatedPolicy == OBJC_ASSOCIATION_ASSIGN)//需解决野指针问题
    {
        [[EMTXWeakRefTable sharedInstance] setObject:value forKey:[NSString stringWithFormat:@"%@-%p", propertyName, property]];
    }
}

- (objc_AssociationPolicy)associatedPolicyForProperty:(NSString *)propertyName outProperty:(void **)property
{
    objc_AssociationPolicy associationPolicy = OBJC_ASSOCIATION_ASSIGN;
    objc_property_t p = class_getProperty(self.class, propertyName.UTF8String);
    NSString *attrs = @(property_getAttributes(p));//&:stong; C:copy W:weak N:nonatomic    
    if ([attrs rangeOfString:@"&"].location != NSNotFound)
    {
        if ([attrs rangeOfString:@"N"].location != NSNotFound)
        {
            associationPolicy = OBJC_ASSOCIATION_RETAIN_NONATOMIC;
        }
        else {
            associationPolicy = OBJC_ASSOCIATION_RETAIN;
        }
    }
    else if ([attrs rangeOfString:@"C"].location != NSNotFound){
        if ([attrs rangeOfString:@"N"].location != NSNotFound)
        {
            associationPolicy = OBJC_ASSOCIATION_COPY_NONATOMIC;
        }
        else {
            associationPolicy = OBJC_ASSOCIATION_COPY;
        }
    }
    *property = p;
    return associationPolicy;
}

@end
