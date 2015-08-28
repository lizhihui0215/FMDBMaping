//
//  EntitySchema.m
//  FMDBMapping
//
//  Created by 李智慧 on 8/25/15.
//  Copyright (c) 2015 lizhihui. All rights reserved.
//

#import "EntitySchema.h"
#import "DynamicEntity.h"
#import "Entity.h"
#import "EntityProperty.h"
#import <objc/runtime.h>
#import "EntityProperty_Private.h"
@implementation EntitySchema

+ (EntitySchema *)schemaForEntityClass:(Class)entityClass {
    EntitySchema *schema = [[EntitySchema alloc] init];
    
    NSString *className = NSStringFromClass(entityClass);
    
    schema.className = className;
    schema.entityClass = entityClass;
    schema.accessorClass = [DynamicEntity class];
    schema.tableName = [entityClass tableName];
    
    // create array of properties, inserting properties of  superclasses first
    
    Class cls = entityClass;
    
    
    NSArray *properties = @[];
    
    
    while (cls != [Entity class]) {
        properties = [EntitySchema propertiesForClass:cls];
        
        cls = [cls superclass];
    }
    schema.properties = properties;
    
    
    return schema;
}


+ (NSArray *)propertiesForClass:(Class)entityClass {
    
    
    NSArray *ignoreProperties = [entityClass ignoreProperties];
    
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList(entityClass, &count);
    
    NSMutableArray *propertyArray = [NSMutableArray array];
    
    NSSet *indexed = [[NSSet alloc] initWithArray:[entityClass indexedProperties]];
    
    for (unsigned int i = 0; i < count; i++) {
        NSString *propertyName = @(property_getName(properties[i]));
        if ([ignoreProperties containsObject:propertyName]){
            continue;
        }
        
        
        EntityProperty *property = [[EntityProperty alloc] initWithName:propertyName
                                                                indexed:[indexed containsObject:propertyName]
                                                               property:properties[i]];
        
        
        
        [propertyArray addObject:property];
    }
    
    for (NSArray *optionalProperties in [entityClass optionalPropertyNames]) {
        for (EntityProperty *property in propertyArray) {
            property.optional = [optionalProperties containsObject:property.name];
        }
    }
    
    free(properties);
    
    return propertyArray;
}

- (NSArray *)validateSQLFieldProperties{
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type != %d and type != %d and type != %d",ZHPropertyTypeObject,ZHPropertyTypeArray,ZHPropertyTypeAny];
//    [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//        EntityProperty *property = evaluatedObject;
//
//    }];
    
    
   NSArray *a = [self.properties filteredArrayUsingPredicate:predicate];
   return  a;
}

- (NSArray *)objectArray{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %d and type != %d ",ZHPropertyTypeObject,ZHPropertyTypeAny];
   return  [self.properties filteredArrayUsingPredicate:predicate];
}

- (NSArray *)sssArray{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %d and type != %d",ZHPropertyTypeArray,ZHPropertyTypeAny];
    return  [self.properties filteredArrayUsingPredicate:predicate];
}

- (instancetype)copyWithZone:(NSZone *)zone{
    EntitySchema *entitySchema = [[EntitySchema allocWithZone:zone] init];
    entitySchema.entityClass = self.entityClass;
    entitySchema.className = self.className;
    entitySchema.accessorClass = self.accessorClass;
    entitySchema.standaloneClass = self.standaloneClass;
    entitySchema.properties = [[NSArray allocWithZone:zone] initWithArray:self.properties copyItems:YES];
    return entitySchema;
    
}

- (NSString *)description {
    NSMutableString *propertiesString = [NSMutableString string];
    for (EntityProperty *property in self.properties) {
        [propertiesString appendFormat:@"\t%@\n", [property.description stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"]];
    }
    return [NSString stringWithFormat:@"%@ {\n%@}", self.className, propertiesString];
}

@end
