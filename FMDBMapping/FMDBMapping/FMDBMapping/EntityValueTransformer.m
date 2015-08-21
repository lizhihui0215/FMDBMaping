//
//  EntityValueTransformer.m
//  FMDBMapping
//
//  Created by 李智慧 on 8/21/15.
//  Copyright (c) 2015 lizhihui. All rights reserved.
//

#import "EntityValueTransformer.h"
#import "DatabaseManager.h"

@implementation EntityValueTransformer
- (instancetype)init
{
    self = [super init];
    if (self) {
        _primitivesNames = @{@"f":@(FTFloat),
                             @"i":@(FTInteger),
                             @"d":@(FTDouble),
                             @"l":@(FTInteger),
                             @"c":@(FTInteger),
                             @"s":@(FTInteger),
                             @"q":@(FTInteger),
                             //and some famos aliases of primitive types
                             // BOOL is now "B" on iOS __LP64 builds
                             @"I":@(FTInteger),
                             @"Q":@(FTInteger),
                             @"B":@(FTInteger),
                             @"NSString":@(FTText),
                             @"@?":@"Block"};
    }
    return self;
}
@end
