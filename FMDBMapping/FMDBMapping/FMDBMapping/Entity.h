//
//  Entity.h
//  FMDBMapping
//
//  Created by 李智慧 on 8/21/15.
//  Copyright © 2015 lizhihui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHGlobalManager.h"
#import "ZHArray.h"
@class EntitySchema;

@interface Entity : NSObject
@property (nonatomic, strong, readwrite) ZHGlobalManager *manager;
@property (nonatomic, strong, readonly) EntitySchema *schema;

+ (NSArray *)ignoreProperties;

+ (NSArray *)indexedProperties;

+ (NSArray *)optionalPropertyNames;

+ (EntitySchema *)sharedSchema;

- (NSString *)tableName;

- (NSMutableDictionary *)sqlMappingField;

+ (NSString *)tableName;


@end
