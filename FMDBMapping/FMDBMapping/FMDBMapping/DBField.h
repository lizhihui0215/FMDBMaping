//
// Created by 李智慧 on 8/25/15.
// Copyright (c) 2015 lizhihui. All rights reserved.
//


#ifndef __DBField_H_
#define __DBField_H_

/*!
 *  DBField object is a easy way to create a table fields
 */
@interface DBField : NSObject

/*! table field name */
@property (nonatomic, strong, readonly) NSString *fieldName;

/*!  the type of the field */
@property (nonatomic, assign, readonly) enum FieldType type;

/*!  default value of the field */
@property (nonatomic, strong, readonly) id defaultValue;

/*!
 *  create a DBField use specified name with type
 *
 *  @param fieldName field name
 *  @param type      field type
 *  @param defaultValue field default value
 *
 *  @return DBField
 */
- (instancetype)initWithName:(NSString *)fieldName type:(FieldType)type defaultValue:(id)defaultValue;

- (NSString *)sqlField;

/*!
 *  create a DBField use specified name with type
 *
 *  @param fieldName field name
 *  @param type      field type
 *  @param defaultValue field default value
 *
 *  @return DBField
 */
+ (instancetype)fieldWithName:(NSString *)fieldName type:(FieldType)type defaultValue:(id)defaultValue;
@end

#import <Foundation/Foundation.h>

#endif //__DBField_H_
