//
//  EntitySchema.h
//  FMDBMapping
//
//  Created by 李智慧 on 8/25/15.
//  Copyright (c) 2015 lizhihui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntitySchema : NSObject

@property(nonatomic, copy) NSString *className;

@property(nonatomic, strong) Class entityClass;

@property(nonatomic, strong) Class accessorClass;

@property(nonatomic, strong) NSArray *properties;

+ (EntitySchema *)schemaForEntityClass:(Class)pClass;

+ (NSArray *)propertiesForClass:(Class)entityClass;
@end
