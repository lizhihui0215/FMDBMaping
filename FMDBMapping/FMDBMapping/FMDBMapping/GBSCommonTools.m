//
//  GBSCommonTools.m
//  GBSAssistant
//
//  Created by 李智慧 on 8/21/15.
//  Copyright (c) 2015 lizhihui. All rights reserved.
//

#import "GBSCommonTools.h"
@interface GBSCommonTools()

@end
@implementation GBSCommonTools
+ (NSDateFormatter *)dateFormatterFromTemplate:(NSString *)template{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    //    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:template];
    return dateFormatter;
}
@end
