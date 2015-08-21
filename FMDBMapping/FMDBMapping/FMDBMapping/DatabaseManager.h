//
// Created by lizhihui on 14/12/2.
// Copyright (c) 2014 lizhihui. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMResultSet;

/**
 *  The field type.
 */
typedef NS_ENUM(NSInteger, FieldType){
    /*!  text */
    FTText = 1,
    
    /*! 64 bit decimal. */
    FTDouble,
    
    /*! 32 bit decimal.*/
    FTFloat,
    
    /*!  32 bit decimal. */
    FTInteger,
    
    /*! binary object.*/
    FTBlob,
    
    /*!  date yy mm dd.*/
    FTDate,
    
    /*!  time hh mm ss.*/
    FTTime,
    
    /*! timestamp yyy mm dd hh mm ss sss .*/
    FTDatetime
};

/*!
 *  An DatabaseManager object  lets you manager the Calico's database
 */
@interface DatabaseManager : NSObject
///----------------------------
/// @name Creating a DatabaseManager
///----------------------------
/*!
 *  Returns the default singleton instance.
 */
+ (instancetype)defaultManager;

/*!
 *  create the DatabaseManager use the path
 *
 *  @param aPath The file path of the database
 *
 *  @return the `DatabaseManager` object. or nil if on error
 */
- (instancetype)initWithPath:(NSString *)aPath;

/*!
 *  create table use specified tableName and fields
 *
 *  @param tableName a string which is the created table name
 *  @param fields    a array which is contain a mount of DBField
 *
 *  @return YES create successful , NO if occur some error
 */
- (BOOL)createTableWithName:(NSString *)tableName  fields:(NSArray *)fields __attribute__((nonnull(1,2)));

//TODO: add comment
- (FMResultSet *)selectFromTable:(NSString *)tableName fields:(NSArray *)fields conditions:(NSString *)conditions __attribute__((nonnull(1,2,3)));

//TODO: add comment
- (BOOL)deleteFromTableWithName:(NSString *)tableName conditions:(NSString *)conditions __attribute__((nonnull(1,2)));

//TODO: add comment
- (BOOL)insertIntoTableWithName:(NSString *)tableName fields:(NSDictionary *)fields __attribute__((nonnull(1,2)));

@end

/*!
 *  DBField object is a easy way to create a table fields
 */
@interface DBField : NSObject

/*! table field name */
@property (nonatomic, strong, readonly) NSString *fieldName;

/*!  the type of the field */
@property (nonatomic, assign, readonly) FieldType type;

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