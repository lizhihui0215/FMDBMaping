//
//  Schema.m
//  FMDBMapping
//
//  Created by 李智慧 on 8/25/15.
//  Copyright (c) 2015 lizhihui. All rights reserved.
//

#import "Schema.h"
#import "Entity.h"
#import "EntitySchema.h"
#import "EntityProperty.h"
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

@interface Schema()
@property (nonatomic, readwrite) NSMutableDictionary *entitySchemaByName;
@end

@implementation Schema

- (void)setObjectSchema:(NSArray *)objectSchema{
    _objectSchema = objectSchema;
    _entitySchemaByName = [NSMutableDictionary dictionaryWithCapacity:objectSchema.count];
    for (EntitySchema *entity in objectSchema) {
        [_entitySchemaByName setObject:entity forKey:entity.className];
    }
}



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
        Class objectBaseClass = [Entity class];
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
        [schemaArray addObject:schema];
        
        // exchange the sharedSchema at the runtime
        Class metaClass = objc_getMetaClass(class_getName(cls));
        IMP imp = imp_implementationWithBlock(^{return schema ;});
        class_replaceMethod(metaClass, @selector(sharedSchema), imp, "@:");
        
        // add accesstor
        schema.standaloneClass = [Schema standaloneAccessorWithClass:cls
                                                              schema:schema];
      
    }
    s_sharedSchema = schema;
}

+ (Class)standaloneAccessorWithClass:(Class)class schema:(EntitySchema *)schame{
    NSString *className = NSStringFromClass(class);
    NSString *accessorClassName = [@"xxx" stringByAppendingString:className];
    
    Class accClass = objc_getClass(accessorClassName.UTF8String);
    
    if (!accClass){
        accClass = objc_allocateClassPair(class, accessorClassName.UTF8String, 0);
        objc_registerClassPair(accClass);
    }
    
    // overide getters / setters for each property
    for (NSInteger i = 0; i < [schame.properties count]; i++) {
        EntityProperty *property = schame.properties[i];
        IMP (^getterImplementation)(EntityProperty *property) = ^(EntityProperty *property){
            
            if (property.type == ZHPropertyTypeArray) {
                return imp_implementationWithBlock(^(Entity *obj){
                    typedef id (*getter_type)(Entity *,SEL);
                    getter_type supperGetter = (getter_type)[[obj superclass] instanceMethodForSelector:property.getterSel];
                    return supperGetter(obj,property.getterSel);
                });
            }
            return (IMP) nil;
        };
        
        IMP getterIMP = getterImplementation(property);
        
        if (getterIMP && property.getterSel){
            
            class_replaceMethod(accClass, property.getterSel, getterIMP, getterTypeStringForObjcCode(property.objcType));
        }
        
        IMP (^setterImplementation)(EntityProperty *property) = ^(EntityProperty *property){
            if (property.type == ZHPropertyTypeArray){
                return imp_implementationWithBlock(^(Entity *obj,id<NSFastEnumeration>ar){
                    // make copy when setting (as is the case for all other variants)
                    ZHArray *array = [[ZHArray alloc] init];
                    typedef void(*setter_type) (Entity *,SEL,ZHArray *array);
                    setter_type superSetter = (setter_type)[[obj superclass] instanceMethodForSelector:property.setterSel];
                    superSetter(obj,property.setterSel,array);
                });
            }
            return (IMP) nil;
        };
        
        
        IMP setterIMP = setterImplementation(property);
        if (setterIMP && property.setterSel) {
            class_replaceMethod(accClass, property.setterSel, setterIMP, setterTypeStringForObjcCode(property.objcType));
        }
        
    }
    return accClass;
}

// macros/helpers to generate objc type strings for registering methods
#define GETTER_TYPES(C) C ":@"
#define SETTER_TYPES(C) "v:@" C

// setter type strings
// NOTE: this typecode is really the the first charachter of the objc/runtime.h type
//       the @ type maps to multiple core types (string, date, array, mixed, any which are id in objc)
static const char *setterTypeStringForObjcCode(char code) {
    switch (code) {
        case 's': return SETTER_TYPES("s");
        case 'i': return SETTER_TYPES("i");
        case 'l': return SETTER_TYPES("l");
        case 'q': return SETTER_TYPES("q");
        case 'f': return SETTER_TYPES("f");
        case 'd': return SETTER_TYPES("d");
        case 'B': return SETTER_TYPES("B");
        case 'c': return SETTER_TYPES("c");
        case '@': return SETTER_TYPES("@");
        default: @throw [NSException exceptionWithName:@""
                                                reason:@"Invalid accessor code"
                                              userInfo:nil];
    }
}

// getter type strings
// NOTE: this typecode is really the the first charachter of the objc/runtime.h type
//       the @ type maps to multiple core types (string, date, array, mixed, any which are id in objc)
static const char *getterTypeStringForObjcCode(char code) {
    switch (code) {
        case 's': return GETTER_TYPES("s");
        case 'i': return GETTER_TYPES("i");
        case 'l': return GETTER_TYPES("l");
        case 'q': return GETTER_TYPES("q");
        case 'f': return GETTER_TYPES("f");
        case 'd': return GETTER_TYPES("d");
        case 'B': return GETTER_TYPES("B");
        case 'c': return GETTER_TYPES("c");
        case '@': return GETTER_TYPES("@");
        default: @throw [NSException exceptionWithName:@""
                                                reason:@"Invalid accessor code"
                                              userInfo:nil];
    }
}

- (id)copyWithZone:(NSZone *)zone {
    Schema *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy.objectSchema = [[NSArray allocWithZone:zone] initWithArray:self.objectSchema copyItems:YES];
        
        copy.entitySchemaByName = [[NSMutableDictionary allocWithZone:zone] initWithDictionary:self.entitySchemaByName copyItems:YES];;
    }

    return copy;
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
