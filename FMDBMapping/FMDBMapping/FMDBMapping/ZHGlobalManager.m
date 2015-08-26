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
@interface ZHGlobalManager()
@property (nonatomic, strong, readwrite) Schema *schema;
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

- (void)addEntity:(Entity *)entity{
    EntitySchema *schema = entity.schema;
    
    
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
        self.schema = [Schema sharedSchema];
    }
    return self;
}
@end
