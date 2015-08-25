//
//  Schema.m
//  FMDBMapping
//
//  Created by 李智慧 on 8/25/15.
//  Copyright (c) 2015 lizhihui. All rights reserved.
//

#import "Schema.h"
#import "BaseEntity.h"
#import "EntitySchema.h"
#import <objc/runtime.h>
static Schema *s_sharedSchema;
static NSMutableDictionary *s_localNameToClass;
static inline BOOL ZHIsKindOfClass(Class class1, Class class2) {
    while (class1) {
        if (class1 == class2) return YES;
        class1 = class_getSuperclass(class1);
    }
    return NO;
}

@implementation Schema


+ (void)initialize{
    static BOOL initialized;
    if (initialized) return;
    initialized = YES;
    
    
    NSMutableArray *schemaArray = [NSMutableArray array];
    
    Schema *schema = [[Schema alloc] init];
    
    unsigned int numClasses;
    
    Class *classes = objc_copyClassList(&numClasses);
    // first create class to name mapping so we can do array validation when creating object schema
    s_localNameToClass = [NSMutableDictionary dictionary];
    
    for (unsigned int i = 0 ; i < numClasses; i++) {
        Class cls = classes[i];
        Class objectBaseClass = [BaseEntity class];
        if (!ZHIsKindOfClass(cls, objectBaseClass)){
            // ingore all other class
            continue;
        }
        NSString *className = NSStringFromClass(cls);
        if (s_localNameToClass[className]){
            NSString *message = [NSString stringWithFormat:@"Entity subclasses with the same name cannot be included twice in the same target. Please make sure '%@' is only linked once to your current target.", className];
            @throw [NSException exceptionWithName:@""
                                           reason:message
                                         userInfo:nil];
        }
       
        s_localNameToClass[className] = cls;
    }
    
    // process all Entity subclasses
    for (Class cls in s_localNameToClass.allValues) {
        EntitySchema *schema = [EntitySchema schemaForEntityClass:cls];
    }
    
    
    NSLog(@"s_localNameToClass %@",s_localNameToClass);
    
}



+ (instancetype)sharedSchema{
    return s_sharedSchema;
}

+ (Class)classForString:(NSString *)className {
    Class cls = s_localNameToClass[className];
    if (cls) return cls;
    
    return NSClassFromString(className);
}
@end
