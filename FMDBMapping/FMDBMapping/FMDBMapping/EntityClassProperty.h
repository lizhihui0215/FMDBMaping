//
//  EntityClassProperty.h
//  FMDBMapping
//
//  Created by 李智慧 on 8/21/15.
//  Copyright (c) 2015 lizhihui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseManager.h"
enum kCustomizationTypes{
    kNotInspected = 0,
    kCustom,
    kNo
};

typedef enum kCustomizationTypes PropertySetterType;
typedef enum kCustomizationTypes PropertyGetterType;


@interface EntityClassProperty : NSObject
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) FieldType type;
@property (strong, nonatomic) NSString *structName;
@property (copy, nonatomic) NSString *protocol;
@property (assign, nonatomic) BOOL isOptional;
@property (assign, nonatomic) BOOL isMutable;
@property (assign, nonatomic) BOOL convertsOnDemand;
@property (assign, nonatomic) BOOL isIndex;
@property (assign, nonatomic) PropertyGetterType getterType;
@property (assign, nonatomic) SEL customGetter;
@property (assign, nonatomic) PropertyGetterType setterType;

@property (assign, nonatomic) SEL customSetter;
@end
