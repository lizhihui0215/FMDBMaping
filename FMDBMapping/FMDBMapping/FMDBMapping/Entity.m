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

@implementation Entity
{
    EntitySchema *_entitySchema;
}

+ (EntitySchema *)sharedSchema{
    
    return nil;
}

- (instancetype)init
{
    self = [super init];
    if (self && [Schema sharedSchema]) {
        _entitySchema = [[self class] sharedSchema];
        NSLog(@"_entitySchema %@",_entitySchema);
    }
    return self;
}





+ (void)initialize{
    static BOOL initialized;
    if(initialized) return;
    initialized = YES;
    

    
    
    
    
}



- (void)select{
    
}

- (void)delete{
    
}

- (void)update{
    
}

- (void)save{
    

    
    
}




@end


