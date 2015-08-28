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

+ (void)replaceAccessorsClass:(Class)class property:(EntityProperty *)property{
    
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

- (NSString *)description {
    NSMutableString *propertiesString = [NSMutableString string];
    for (EntityProperty *property in self.properties) {
        [propertiesString appendFormat:@"\t%@\n", [property.description stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"]];
    }
    return [NSString stringWithFormat:@"%@ {\n%@}", self.className, propertiesString];
}

@end
