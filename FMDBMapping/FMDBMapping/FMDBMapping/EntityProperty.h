//
//  EntityProperty.h
//  FMDBMapping
//
//  Created by 李智慧 on 8/21/15.
//  Copyright (c) 2015 lizhihui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "ZHConstants.h"



@interface EntityProperty : NSObject<NSCopying>
@property (nonatomic, readonly, nonnull) NSString *name;
@property (nonatomic, readonly) ZHPropertyType type;

@property (nonatomic, readonly) BOOL indexed;

@property (nonatomic, readonly, copy, nullable) NSString *entityClassName;

@property (nonatomic, readonly) BOOL optional;







// setter
@property (nonatomic, copy) NSString *getterName;
@property (nonatomic, copy) NSString *setterName;
@property (nonatomic) SEL getterSel;
@property (nonatomic) SEL setterSel;

// properties
@property (nonatomic, assign) char objcType;
@property (nonatomic, assign) BOOL isPrimary;



- (BOOL)isEqualToProperty:(EntityProperty * __nonnull)property;

- (instancetype)initWithName:(NSString * __nonnull)name
                     indexed:(BOOL)indexed
                    property:(objc_property_t __nonnull)property;
- (NSString *)sqlField;
@end
