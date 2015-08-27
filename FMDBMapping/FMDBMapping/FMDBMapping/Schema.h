//
//  Schema.h
//  FMDBMapping
//
//  Created by 李智慧 on 8/25/15.
//  Copyright (c) 2015 lizhihui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Schema : NSObject <NSCopying>
+ (instancetype)sharedSchema;
@property (nonatomic, readwrite, copy) NSArray *objectSchema;

+ (Class)classForString:(NSString *)className;

- (id)copyWithZone:(NSZone *)zone;
@end
