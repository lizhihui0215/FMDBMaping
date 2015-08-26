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





+ (void)initialize{
    static BOOL initialized;
    if(initialized) return;
    initialized = YES;
    

    
    
    
    
}

@end


