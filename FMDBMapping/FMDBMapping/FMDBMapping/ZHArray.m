//
//  ZHArray.m
//  FMDBMapping
//
//  Created by 李智慧 on 8/27/15.
//  Copyright (c) 2015 lizhihui. All rights reserved.
//

#import "ZHArray.h"
#import "Entity.h"
@interface ZHArray ()
{
    NSMutableArray *_backingArray;
}
@property (nonatomic, copy) NSString *entityClassName;

@end
@implementation ZHArray
- (instancetype)initWithEntityClassName:(NSString *)entityClassName standalone:(BOOL)standalone
{
    self = [super init];
    if (self) {
        self.entityClassName = entityClassName;
        if (standalone){
            _backingArray = [NSMutableArray array];
        }
    }
    return self;
}

- (void)addObject:(Entity *)entity{
    [_backingArray addObject:entity];
}
@end
