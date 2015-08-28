//
//  EntitySchema.h
//  FMDBMapping
//
//  Created by 李智慧 on 8/25/15.
//  Copyright (c) 2015 lizhihui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntitySchema : NSObject<NSCopying>

@property(nonatomic, copy) NSString *className;

@property(nonatomic, assign) Class entityClass;

@property(nonatomic, assign) Class accessorClass;

@property (nonatomic, assign) Class standaloneClass;

@property(nonatomic, strong) NSArray *properties;

@property (nonatomic, copy) NSString *tableName;
+ (EntitySchema *)schemaForEntityClass:(Class)pClass;

+ (NSArray *)propertiesForClass:(Class)entityClass;

- (NSArray *)validateSQLFieldProperties;


- (NSArray *)objectArray;
- (NSArray *)sssArray;

@end
