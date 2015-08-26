//
//  User.h
//  FMDBMapping
//
//  Created by 李智慧 on 8/21/15.
//  Copyright © 2015 lizhihui. All rights reserved.
//

#import "Entity.h"
@protocol Dog <NSObject>
@end
@class Person;
@interface Dog : Entity
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Person *person;

@end




@interface Person : Entity
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) NSArray<Dog> *dogs;
@end
