//
//  Entity.h
//  FMDBMapping
//
//  Created by 李智慧 on 8/21/15.
//  Copyright © 2015 lizhihui. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol test <NSObject>

@end
@interface Entity : NSObject
@property (nonatomic, strong) NSString *tableName;

- (instancetype)initWithTableName:(NSString *)tableName;

- (void)save;

+ (instancetype)entityWithTableName:(NSString *)tableName;


@end
