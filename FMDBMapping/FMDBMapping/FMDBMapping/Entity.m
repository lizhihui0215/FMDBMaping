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
{
    NSMutableArray *_test;
}
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

+ (NSString *)tableName{
    return NSStringFromClass([self class]);
}

- (instancetype)init
{
    self = [super init];
    if (self && [Schema sharedSchema]) {
        self.schema = [[self class] sharedSchema];
        NSLog(@"_entitySchema %@",self.schema);
        object_setClass(self, self.schema.standaloneClass);
        _test = [NSMutableArray array];
    }
    return self;
}


- (void)save{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        

    
    
    NSArray *aaa =  [self.schema objectArray];
    
    for (EntityProperty *p in aaa) {
        Entity *entity = [self valueForKey:p.name];
        [entity save];
    }
    
    NSArray *bbb = [self.schema sssArray];
    
    for (EntityProperty *p in bbb) {
        NSArray *array = [self valueForKey:p.name];
        for (Entity *entity in array) {
            [entity save];
        }
    }

    id value = nil;
    for (EntityProperty *property in [self.schema validateSQLFieldProperties]) {
        value = [self valueForKey:property.name];
      
        [dictionary setValue:value forKey:property.name];

    }
    
    [[DatabaseManager defaultManager] insertIntoTableWithName:[self tableName] fields:dictionary];
    
    NSLog(@"dic %@",dictionary);
    
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
    return NSStringFromClass([self superclass]);
}

@end


