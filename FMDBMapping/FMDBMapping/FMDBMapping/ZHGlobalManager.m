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

- (NSArray *)test:(NSMutableDictionary *)dic array:(NSMutableArray *)array tableName:(NSString *)tableName{
    
    NSMutableDictionary *dictemp = [NSMutableDictionary dictionary];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSMutableDictionary class]]){
            [self test:obj array:array tableName:key];
            [dic removeObjectForKey:key];
        }else if ([obj isKindOfClass:[NSArray class]]){
            for (NSMutableDictionary *dicc in obj) {
                [self test:dicc array:array tableName:key];
                [dic removeObjectForKey:key];
            }
        }else{
            [dictemp setObject:obj forKey:key];
        }
    }];
    
    
    [array addObject:@{tableName : dictemp}];
    
    return array;
}

- (void)addEntity:(Entity *)entity{
 
    
    // entity sql field
    [entity save];
    
//    NSMutableDictionary *sqlField = [entity sqlMappingField];
//    
//    
//    NSMutableArray *array = [NSMutableArray array];
    
    
//    NSArray *a =  [self test:sqlField array:array tableName:[entity tableName]];
    
    
    
    
//    NSLog(@"array %@",a);
    
    
    
    
    
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
