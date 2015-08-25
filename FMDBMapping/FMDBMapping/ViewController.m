//
//  ViewController.m
//  FMDBMapping
//
//  Created by 李智慧 on 8/21/15.
//  Copyright (c) 2015 lizhihui. All rights reserved.
//

#import "ViewController.h"



#import "User.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    User *user = [[User alloc] init];
    user.name = @"aaa";
    user.age = 10;
    user.isBoy = NO;
    user.data = [@"abcsadasdsadasda" dataUsingEncoding:NSUTF8StringEncoding];
    user.date = [NSDate date];
    
    [user save];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
