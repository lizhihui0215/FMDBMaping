//
//  Entity.m
//  FMDBMapping
//
//  Created by 李智慧 on 8/21/15.
//  Copyright © 2015 lizhihui. All rights reserved.
//

#import "Entity.h"
#import "DatabaseManager.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "EntityClassProperty.h"
#import "EntityValueTransformer.h"
static EntityValueTransformer * valueTransformer = nil;

static const char * kClassPropertiesKey;
@implementation Entity
- (instancetype)initWithTableName:(NSString *)tableName {
    self = [super init];
    if (self) {
        self.tableName = tableName;
        [self __setup__];
    }

    return self;
}

+ (instancetype)entityWithTableName:(NSString *)tableName {
    return [[self alloc] initWithTableName:tableName];
}

- (void)__setup__{
    if (!objc_getAssociatedObject(self.class, &kClassPropertiesKey)){
        [self __inspectProperties];
    }
}

//inspects the class, get's a list of the class properties
- (void)__inspectProperties{
    
    NSLog(@"self class %@",self.class);
    
    NSMutableDictionary *propertyIndex = [NSMutableDictionary dictionary];
    
    
    // temo variables for the loops
    
    Class class = [self class];
    NSScanner *scanner = nil;
    NSString *propertyType = nil;
    
    while (class != [Entity class]) {
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
        
        for(unsigned int i = 0; i < propertyCount; i++){
            objc_property_t property = properties[i];
            
            EntityClassProperty *p = [[EntityClassProperty alloc] init];
            
            // get property name
            const char *propertyName = property_getName(property);
            p.name = @(propertyName);
            
            // get property attributes
            const char *attrs = property_getAttributes(property);
            NSString *propertyAttributes = @(attrs);
            NSArray *attributeItems = [propertyAttributes componentsSeparatedByString:@","];
            
            
            // read-only
            [attributeItems containsObject:@"R"];
            
            
            if ([propertyAttributes hasPrefix:@"Tc,"]){
                // mask BOOLs as structs so they can have custom convertors
                p.structName = @"BOOL";
            }
            
            scanner = [NSScanner scannerWithString:propertyAttributes];
            
            [scanner scanUpToString:@"T" intoString:nil];
            [scanner scanString:@"T" intoString:nil];
            
            // check if the property is an instance of a class
            if ([scanner scanString:@"@\"" intoString:&propertyType]){
                [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"] intoString:&propertyType];
                NSDictionary *_primitivesNames = valueTransformer.primitivesNames[propertyType];
                
                propertyType = _primitivesNames[propertyType];
                p.type = [propertyType integerValue];
                
                p.isMutable = ([propertyType rangeOfString:@"Mutable"].location != NSNotFound);
                
                while ([scanner scanString:@"<" intoString:NULL]) {
                    NSString *protocolName = nil;
                    [scanner scanUpToString:@">" intoString:&protocolName];
                    p.protocol = protocolName;
                    
                    [scanner scanString:@">" intoString:NULL];
                }
            }
            // check if the property is structure
            else if ([scanner scanString:@"{" intoString:&propertyType]){
                [scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet]
                                    intoString:&propertyType];
                p.structName = propertyType;
            }
            // the property must be a promitive
            else{
                // the property contains a promitive data type
                [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@","] intoString:&propertyType];
                
                // get the full name if the promitive type
                NSDictionary *_primitivesNames = valueTransformer.primitivesNames[propertyType];
                
                propertyType = _primitivesNames[propertyType];
                p.type = [propertyType integerValue];
                
            }
            
            
            if (p && ![propertyIndex objectForKey:p.name]){
                [propertyIndex setValue:p forKey:p.name];
            }
        }
        
        class = [class superclass];
        free(properties);
        objc_setAssociatedObject(
                                 self.class,
                                 &kClassPropertiesKey,
                                 [propertyIndex copy],
                                 OBJC_ASSOCIATION_RETAIN);
    }
}

- (void)select{
    
}

- (void)delete{
    
}

- (void)update{
    
}

- (void)save{
    
    
    NSDictionary *propertiesDic =  objc_getAssociatedObject(self.class,
                                     &kClassPropertiesKey);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (EntityClassProperty *property in propertiesDic.allValues) {
        NSLog(@"property %@",property);
//        DBField *filed = [DBField fieldWithName:self.tableName
//                                           type:property.type
//                                   defaultValue:nil];
//        [array addObject:filed];
        dic[property.name] = [self valueForKey:property.name];
        
        
    }
    //TODO: excute db sql
    DatabaseManager *db = [DatabaseManager defaultManager];
    
    [db insertIntoTableWithName:self.tableName
                         fields:dic];
    
    
}

@end
