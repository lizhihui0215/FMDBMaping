//
//  User.h
//  FMDBMapping
//
//  Created by 李智慧 on 8/21/15.
//  Copyright © 2015 lizhihui. All rights reserved.
//

#import "Entity.h"
@class Dog;

@interface Child : Entity
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSString *toys;
@property (nonatomic, strong) Dog *dog;
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
@property (nonatomic, strong) NSArray<Dog> *dogs;
#pragma clang diagnostic pop
@property (nonatomic, strong) Child *chind;
@end
