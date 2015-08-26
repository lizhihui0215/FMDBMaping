//
//  ZHGlobalManager.h
//  FMDBMapping
//
//  Created by 李智慧 on 8/26/15.
//  Copyright © 2015 lizhihui. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Schema;
@class Entity;
@interface ZHGlobalManager : NSObject

@property (nonatomic, strong, readonly) Schema *schema;

+ (instancetype)defaultManager;

- (void)addEntity:(Entity *)entity;
@end
