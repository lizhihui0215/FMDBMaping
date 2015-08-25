//
// Created by 李智慧 on 8/25/15.
// Copyright (c) 2015 lizhihui. All rights reserved.
//

#import "DatabaseManager.h"
#include "DBField.h"

@interface DBField()

/*!
 *  return sql type string
 *
 *  @param type the field type
 *
 *  @return sql type string
 */
- (NSString *)fieldType:(FieldType)type;
@end

@implementation DBField

#pragma mark Life Cycle
+ (instancetype)fieldWithName:(NSString *)fieldName
                         type:(FieldType)type
                 defaultValue:(id)defaultValue{
    return [[self alloc] initWithName:fieldName type:type defaultValue:defaultValue];
}

- (instancetype)initWithName:(NSString *)fieldName
                        type:(FieldType)type
                defaultValue:(id)defaultValue
{
    self = [super init];
    if (self) {
        _fieldName = fieldName;
        _type = type;
        _defaultValue = defaultValue;
    }
    return self;
}


- (NSString *)sqlField{
    NSString *fieldType = [self fieldType:self.type];
    NSString *defaultVaule = [self fieldDefaultValue:self.defaultValue];
    NSMutableString *sqlField = [NSMutableString stringWithFormat:@"%@ %@ %@",self.fieldName,fieldType,defaultVaule];
    return sqlField;
}

- (NSString *)fieldDefaultValue:(id)value {
    if (!value) return @"";
    NSString *defaultVaule = nil;
    switch (self.type) {
        case FTBlob:
        case FTText:
        case FTDouble:
        case FTFloat:
        case FTInteger:
            defaultVaule = [NSString stringWithFormat:@"default %@",value];
            break;
        case FTDate:
            defaultVaule = @"default (date('now'))";
            break;
        case FTTime:
            defaultVaule = @"default (date('now','localtime'))";
            break;
        case FTDatetime:
            defaultVaule = @"default (datetime('now','localtime'))";
            break;

        default:
            break;
    }

    return defaultVaule;
}

- (NSString *)fieldType:(FieldType)type {
    NSString *fieldType = nil;
    switch (type) {
        case FTText:
            fieldType = @"text";
            break;
        case FTDouble:
            fieldType = @"double";
            break;
        case FTFloat:
            fieldType = @"float";
            break;
        case FTInteger:
            fieldType = @"integer";
            break;
        case FTBlob:
            fieldType = @"blob";
            break;
        case FTDate:
            fieldType = @"date";
            break;
        case FTTime:
            fieldType = @"time";
            break;
        case FTDatetime:
            fieldType = @"datetime";
            break;

        default:
            break;
    }

    return fieldType;
}

@end