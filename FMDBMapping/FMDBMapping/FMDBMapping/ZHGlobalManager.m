//
//  ZHGlobalManager.m
//  FMDBMapping
//
//  Created by 李智慧 on 8/26/15.
//  Copyright © 2015 lizhihui. All rights reserved.
//

#import "ZHGlobalManager.h"
#import "Entity.h"
#import "Schema.h"
#import "DatabaseManager.h"
#import "EntitySchema.h"
#import "EntityProperty.h"
@interface ZHGlobalManager()
@property (nonatomic, copy, readwrite) Schema *schema;

@property (nonatomic, copy, readwrite) NSString *path;
@property (nonatomic, copy, readwrite) NSString *key;
@property (nonatomic, assign, readwrite) BOOL readOnly;
@property (nonatomic, assign, readwrite) BOOL inMemory;
@property (nonatomic, assign, readwrite) BOOL dynamic;
@property (nonatomic, strong, readwrite) DatabaseManager *dbManager;


@end
@implementation ZHGlobalManager
+ (instancetype)defaultManager{
    
    return [[self alloc] initWithPath:@""
                                  key:nil
                             readOnly:NO
                             inMemory:NO
                              dynamic:NO
                                error:nil];
}

- (void)__reverseTransform:(id)value forProperty:(EntityProperty *)property{
    Class protocolClass = [Schema classForString:property.entityClassName];
    if (!protocolClass) {
        @throw [NSException exceptionWithName:@""
                                       reason:@"no class for the entity"
                                     userInfo:nil];
    }
    
    //TODO: extract the [Entity class] to the static value
    if ([protocolClass isSubclassOfClass:[Entity class]]){
        if (property.type == ZHPropertyTypeArray){
            for (Entity *entity in value) {
                [self addEntity:entity];
            }
        }
    }
    
}

- (void)addEntity:(Entity *)entity{
    EntitySchema *schema = entity.schema;
    NSString *entityClassName = entity.schema.className;
    entity.manager = self;
    
    id value = nil;
    
    // entity sql field
    NSDictionary *sqlField = [entity sqlMappingField];
    
    
    
    // 1
    @"insert into person values (a,b,c,d)";
    
    // 2
    @"insert into dog values (a,b,c,d)";
    
    for (EntityProperty *property in schema.properties) {
        
        // get object from ivar using key value coding
        value = [entity valueForKey:property.name];
        
        if (property.type == ZHPropertyTypeObject){
            if ([value isKindOfClass:[Entity class]]){
                [self addEntity:value];
            }
            
        }else if (property.type == ZHPropertyTypeArray){
            [self __reverseTransform:value forProperty:property];
        }
        
        
        //TODO: check for custom getter
        
        // optional
        
        // ignore
        
        
        
        
    }
    
//    [self.dbManager insertIntoTableWithName:[entity tableName] fields:@{peoperty.name :value}];
    
     
    
}


- (instancetype)initWithPath:(NSString *)path
                         key:(NSString *)key
                    readOnly:(BOOL)readOnly
                    inMemory:(BOOL)inMemory
                     dynamic:(BOOL)dynamic
                       error:(NSError **)outError
{
    self = [super init];
    if (self) {
        //TODO: try to reuse existing realm first
        
        _path = path;
        _key = key;
        _readOnly = readOnly;
        _inMemory = inMemory;
        _dynamic = dynamic;
        //FIXME: use the path to init
        _dbManager = [DatabaseManager defaultManager];
        self.schema = [[Schema sharedSchema] copy];
    }
    return self;
}
@end
