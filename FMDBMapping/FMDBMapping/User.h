//
//  User.h
//  FMDBMapping
//
//  Created by 李智慧 on 8/21/15.
//  Copyright © 2015 lizhihui. All rights reserved.
//

#import "Entity.h"

@interface User : Entity
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) BOOL isBoy;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSDate *date;




@end
