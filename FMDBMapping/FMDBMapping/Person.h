//
//  User.h
//  FMDBMapping
//
//  Created by 李智慧 on 8/21/15.
//  Copyright © 2015 lizhihui. All rights reserved.
//

#import "Entity.h"

@interface Child : Entity
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSString *toys;
@end

@protocol Dog <NSObject>
@end
@class Person;
@interface Dog : Entity
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Person *person;

@end

@interface Person : Entity
@property (nonatomic, assign) BOOL isMan;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) ZHArray<Dog> *dogs;
@property (nonatomic, strong) Child *chind;
@end
