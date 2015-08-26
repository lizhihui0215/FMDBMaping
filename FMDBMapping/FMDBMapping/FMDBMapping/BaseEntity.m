//
//  BaseEntity.m
//  FMDBMapping
//
//  Created by 李智慧 on 8/25/15.
//  Copyright (c) 2015 lizhihui. All rights reserved.
//

#import "BaseEntity.h"
#import "Schema.h"
@implementation BaseEntity
- (instancetype)init
{
    self = [super init];
    if (self && [Schema sharedSchema]) {
        
        
        
        
        
    }
    return self;
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
@end
