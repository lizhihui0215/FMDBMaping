//
//  EntitySchema.m
//  FMDBMapping
//
//  Created by 李智慧 on 8/25/15.
//  Copyright (c) 2015 lizhihui. All rights reserved.
//

#import "EntitySchema.h"
#import "DynamicEntity.h"
#import "BaseEntity.h"
#import "Entity.h"
#import "EntityProperty.h"
#import <objc/runtime.h>

@implementation EntitySchema

+ (EntitySchema *)schemaForEntityClass:(Class)entityClass {
    EntitySchema *schema = [[EntitySchema alloc] init];
    
    NSString *className = NSStringFromClass(entityClass);
    
    schema.className = className;
    schema.entityClass = entityClass;
    schema.accessorClass = [DynamicEntity class];
    
    // create array of properties, inserting properties of  superclasses first
    
    Class cls = entityClass;
    Class superClass = class_getSuperclass(cls);
    
    NSArray *properties = @[];
    
    
    while (superClass && superClass != [BaseEntity class]) {
        properties = [EntitySchema propertiesForClass:cls];
        
        cls = superClass;
        superClass = class_getSuperclass(superClass);
    }
    schema.properties = properties;
    
    
    
    
    
    
    
    
    
    
    
    return nil;
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
        
        
        
        
        
        
        
    }
    
    
    
    
    free(properties);
    
    
    return nil;
}
@end
