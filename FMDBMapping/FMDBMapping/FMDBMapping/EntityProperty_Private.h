//
//  EntityProperty_Private.h
//  FMDBMapping
//
//  Created by 李智慧 on 8/26/15.
//  Copyright (c) 2015 lizhihui. All rights reserved.
//

#import "EntityProperty.h"

@interface EntityProperty ()
@property (nonatomic, readwrite, nonnull) NSString *name;
@property (nonatomic, readwrite) ZHPropertyType type;
@property (nonatomic, readwrite) BOOL indexed;
@property (nonatomic, readwrite, copy, nullable) NSString *entityClassName;
@property (nonatomic, readwrite) BOOL optional;

@end
