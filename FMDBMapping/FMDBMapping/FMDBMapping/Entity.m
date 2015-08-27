//
//  Entity.m
//  FMDBMapping
//
//  Created by 李智慧 on 8/21/15.
//  Copyright © 2015 lizhihui. All rights reserved.
//

#import "Entity.h"
#import "DatabaseManager.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "EntityProperty.h"
#import "EntityValueTransformer.h"
#import "EntitySchema.h"
#import "Schema.h"


static Class EntityClass = NULL;
static EntityValueTransformer * valueTransformer = nil;
@interface Entity ()
@property (nonatomic, strong, readwrite) EntitySchema *schema;
@end
@implementation Entity
{
    
}

+ (NSArray *)ignoreProperties{
    return nil;
}

+ (NSArray *)indexedProperties{
    return @[];
}

+ (NSArray *)optionalPropertyNames{
    return nil;
}

/**
 *  to be replace at runtime
 *
 *  @return the schema of this class
 */
+ (EntitySchema *)sharedSchema{
    
    return nil;
}

- (instancetype)init
{
    self = [super init];
    if (self && [Schema sharedSchema]) {
        self.schema = [[self class] sharedSchema];
        NSLog(@"_entitySchema %@",self.schema);
    }
    return self;
}


- (NSArray *)sqlMappingField{
    
//    for (EntityProperty *property in schema.properties) {
//        
//        // get object from ivar using key value coding
//        value = [entity valueForKey:property.name];
//        
//        if (property.type == ZHPropertyTypeObject){
//            if ([value isKindOfClass:[Entity class]]){
//                [self addEntity:value];
//            }
//            
//        }else if (property.type == ZHPropertyTypeArray){
//            [self __reverseTransform:value forProperty:property];
//        }
//        
//        
//        //TODO: check for custom getter
//        
//        // optional
//        
//        // ignore
//        
//    }
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    
    id value = nil;

    
    //TODO: to do mapping
    for (EntityProperty *property in self.schema.properties) {
        value = [self valueForKey:property.name];
        
        if ([value isKindOfClass:EntityClass]) {
            value = [value sqlMappingField];
            [dictionary setObject:value forKey:property.name];
            continue;
        }else{
            
            // check built-in transformation
            if (property.type == ZHPropertyTypeArray) {
                value = [self __reverseTransform:value forProperty:property];
                [dictionary setValue:value forKey:property.name];
                continue;
            }
            
            //TODO: add transforme
            
            
            //
            [dictionary setValue:value forKey:property.name];
            
        }
        
        
        
    }
    
    return dictionary;
}

-(id)__reverseTransform:(id)value forProperty:(EntityProperty*)property{
    Class protocolClass = [Schema classForString:property.entityClassName];
    if (!protocolClass) return value;
    
    if ([protocolClass isSubclassOfClass:EntityClass]){
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:[value count]];
        for (Entity *entity in value) {
            if ([entity respondsToSelector:@selector(sqlMappingField)]){
                [tempArray addObject:[entity sqlMappingField]];
            }else{
                [tempArray addObject:entity];
            }
        }
        return [tempArray copy];
    }
    
    return value;
}

+ (void)load{
    EntityClass = NSClassFromString(NSStringFromClass(self));
}

- (NSString *)tableName{
    return NSStringFromClass([self class]);
}


+ (void)initialize{
    static BOOL initialized;
    if(initialized) return;
    initialized = YES;
    

    
    
    
    
}

@end


