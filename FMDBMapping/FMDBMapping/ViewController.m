//
//  ViewController.m
//  FMDBMapping
//
//  Created by 李智慧 on 8/21/15.
//  Copyright (c) 2015 lizhihui. All rights reserved.
//

#import "ViewController.h"

#import "ZHGlobalManager.h"

#import "Person.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Dog *dog = [[Dog alloc] init];
    
    Person *person = [[Person alloc] init];
    person.name = @"name";
    person.birthday = [NSDate date];
    dog.person = person;
    dog.name = @"haha";
    
    
    
    NSLog(@"dog %@",dog);


    ZHGlobalManager *manager = [ZHGlobalManager defaultManager];
    
    [manager addEntity:person];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
