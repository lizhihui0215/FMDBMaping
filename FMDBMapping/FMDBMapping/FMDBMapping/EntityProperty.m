//
//  EntityProperty.m
//  FMDBMapping
//
//  Created by 李智慧 on 8/21/15.
//  Copyright (c) 2015 lizhihui. All rights reserved.
//

#import "EntityProperty.h"
#import "Schema.h"
#import "Entity.h"
#import "EntityProperty_Private.h"
#import "ZHArray.h"

@implementation EntityProperty{
    NSString *_objcRawType;
}
- (BOOL)isEqualToProperty:(EntityProperty *)other {
    return self.type == other.type &&
        self.indexed == other.indexed &&
        self.isPrimary == other.isPrimary &&
        self.optional == other.optional &&
        [self.name isEqualToString:other.name] &&
        (self.entityClassName == other.entityClassName || [self.entityClassName isEqualToString:other.entityClassName]);
}

- (instancetype)initWithName:(NSString * __nonnull)name
                     indexed:(BOOL)indexed
                    property:(objc_property_t __nonnull)property {
    
    self = [super init];
    if(!self) return nil;
    
    self.name = name;
    self.indexed = indexed;
    
    if ([self parseEntityProperty:property]){
        return nil;
    }
    
    if (![self setTypeFromRawType]){
        NSString *reason = [NSString stringWithFormat:@"Can't persist property '%@' with incompatible type. "
                            "Add to ignoredPropertyNames: method to ignore.", self.name];
        @throw [NSException exceptionWithName:@""
                                       reason:reason
                                     userInfo:nil];
    }
    
    
    // update getter/setter names
    [self updateAccessors];
    
    
    
    
    return self;
}
- (void)updateAccessors{
    if (self.name){
        self.getterName = self.name;
    }
    
    if (!self.setterName){
        int asciiCode = [self.name characterAtIndex:0];
        BOOL shouldUppercase = asciiCode >= 'a' && asciiCode <='z';
        NSString *firstChar = [self.name substringToIndex:1];
        firstChar = shouldUppercase ? firstChar.uppercaseString : firstChar;
        self.setterName = [NSString stringWithFormat:@"set%@%@:",firstChar,[self.name substringFromIndex:1]];
    }
    
    self.setterSel = NSSelectorFromString(self.setterName);
    
    self.getterSel = NSSelectorFromString(self.getterName);
}


- (void)setObjcCodeFromType{
    switch (self.type) {
        case ZHPropertyTypeInt:
            self.objcType = 'q';
            break;
        case ZHPropertyTypeBool:
            self.objcType = 'c';
            break;
        case ZHPropertyTypeDouble:
            self.objcType = 'd';
            break;
        case ZHPropertyTypeFloat:
            self.objcType = 'f';
            break;
        case ZHPropertyTypeAny:
        case ZHPropertyTypeArray:
        case ZHPropertyTypeData:
        case ZHPropertyTypeDate:
        case ZHPropertyTypeObject:
        case ZHPropertyTypeString:
            self.objcType = '@';
        default:
            break;
    }

}



- (BOOL)setTypeFromRawType {
    const char *code = _objcRawType.UTF8String;
    self.objcType = *code;
    
    switch (self.objcType) {
        case 's': // short
        case 'i': // int
        case 'l': // long
        case 'q': // long long
            self.type = ZHPropertyTypeInt;
            return YES;
        case 'f': // float
            self.type = ZHPropertyTypeFloat;
            return YES;
        case 'd': // double
            self.type = ZHPropertyTypeDouble;
            return YES;
        case 'c':
        case 'B': // BOOL
            self.type = ZHPropertyTypeBool;
            return YES;
        case '@':{
            static const char arrayPrefix[] = "@\"NSArray<";
            static const int arrayPrefixLen = sizeof(arrayPrefix) - 1;
            if (code[1] == '\0'){
                // string is "@"
                self.type = ZHPropertyTypeAny;
            }else if (strcmp(code, "@\"NSString\"") == 0){
                self.type = ZHPropertyTypeString;
            }else if (strcmp(code, "@\"NSDate\"") == 0){
                self.type = ZHPropertyTypeDate;
            }else if (strcmp(code, "@\"NSData\"") == 0){
                self.type = ZHPropertyTypeData;
            }else if (strncmp(code, arrayPrefix,arrayPrefixLen) == 0){
                self.type = ZHPropertyTypeArray;
                self.entityClassName = [[NSString alloc] initWithBytes:code + arrayPrefixLen
                                                                length:strlen(code + arrayPrefixLen) - 2 // drop trailing >"
                                                              encoding:NSUTF8StringEncoding];
                

                
                //TODO: check if the class is sub class of BaseEntity
                // Class cls = [Schema classForString:self.entityClassName];
            }else if (strcmp(code, "@\"NSNumber\"") == 0){
                @throw [NSException exceptionWithName:@""
                                               reason:@"'NSNumber' is not supported"
                                             userInfo:nil];
            }else if (strcmp(code, "@\"ZHArray\"") == 0){
                @throw [NSException exceptionWithName:@""
                                               reason:@"ZHArray properties require a protocol defining the contained type - example: ZHArray<Person>"
                                             userInfo:nil];
            }else{
                // for objects strip the quotes and @
                NSString *className = [_objcRawType substringWithRange:NSMakeRange(2,_objcRawType.length -3)];
                // verify type
                Class cls = [Schema classForString:className];
                
                //TODO: check if the class is sub class of BaseEntity
                self.type = ZHPropertyTypeObject;
                self.optional = YES;
                self.entityClassName = NSStringFromClass(cls);
            }
            return YES;
        }
            
        default:
            return NO;
            break;
    }
}

- (BOOL)parseEntityProperty:(objc_property_t)property {
    
    unsigned int count;
    objc_property_attribute_t *attributes = property_copyAttributeList(property, &count);
    
    
    BOOL ignore = NO;
    
    for (size_t i = 0; i < count; i++) {
        switch (*attributes[i].name) {
            case 'T':
                _objcRawType = @(attributes[i].value);
                break;
            case 'R':
                ignore = YES;
                break;
            case 'N':
                // nonatomic
                break;
            case 'D':
                // dymamic
                break;
            case 'G':
                self.getterName = @(attributes[i].value);
                break;
            case 'S':
                self.setterName = @(attributes[i].value);
                break;
            default:
                break;
        }
    }
    free(attributes);
    
    return ignore;
}

NSString * SQLTypeFrom(ZHPropertyType type){
    NSString *SQLType;
    switch (type) {
        case ZHPropertyTypeBool:
            SQLType = @"Boolean";
            break;
        case ZHPropertyTypeData:
            SQLType = @"Binary";
            break;
        case ZHPropertyTypeDate:
            SQLType = @"Timestamp";
            break;
        case ZHPropertyTypeDouble:
            SQLType = @"Double";
            break;
        case ZHPropertyTypeFloat:
            SQLType = @"Float";
            break;
        case ZHPropertyTypeInt:
            SQLType = @"Integer";
            break;
        case ZHPropertyTypeString:
            SQLType = @"Text";
            break;
        case ZHPropertyTypeAny:
        case ZHPropertyTypeArray:
        case ZHPropertyTypeObject:
            @throw [NSException exceptionWithName:@""
                                           reason:@"unsupport type for sql field format"
                                         userInfo:nil];
            break;
        default:
            break;
    }
    return SQLType;
}


NSString* SQLDefaultValue(id value, ZHPropertyType type){
    if (value) return @"";
    NSString *defaultValue = nil;
    switch (type) {
        case ZHPropertyTypeBool:
        case ZHPropertyTypeDouble:
        case ZHPropertyTypeFloat:
        case ZHPropertyTypeInt:
        case ZHPropertyTypeString:
            defaultValue = [NSString stringWithFormat:@"default %@",value];
            break;
        case ZHPropertyTypeData:{
            NSString *dataString = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
            defaultValue = [NSString stringWithFormat:@"default %@",dataString];
        }
            break;
        case ZHPropertyTypeDate:
            defaultValue = @"default CURRENT_TIMESTAMP";
            break;
      
        case ZHPropertyTypeAny:
        case ZHPropertyTypeArray:
        case ZHPropertyTypeObject:
            @throw [NSException exceptionWithName:@""
                                           reason:@"unsupport type for sql field format"
                                         userInfo:nil];
            break;
        default:
            break;
    }

    
    
    return defaultValue;
    
}



- (NSString *)sqlField{
    NSString *fieldType = SQLTypeFrom(self.type);
    NSString *defaultValue = SQLDefaultValue(nil,self.type);
    NSMutableString *sqlField = [NSMutableString stringWithFormat:@"%@ %@ %@",self.name,fieldType,defaultValue];
    return sqlField;
}

- (instancetype)copyWithZone:(NSZone *)zone{
    EntityProperty *property = [[EntityProperty allocWithZone:zone] init];
    property.name = self.name;
    property.type = self.type;
    property.objcType = self.objcType;
    property.entityClassName = self.entityClassName;
    property.indexed = self.indexed;
    property.getterName = self.getterName;
    property.setterName = self.setterName;
    property.getterSel = self.getterSel;
    property.setterSel = self.setterSel;
    property.isPrimary = self.isPrimary;
    property.optional = self.optional;
    return property;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ {\n\ttype = %d;\n\tobjectClassName = %@;\n\tindexed = %@;\n\tisPrimary = %@;\n\toptional = %@;\n}", self.name, self.type, self.entityClassName, self.indexed ? @"YES" : @"NO", self.isPrimary ? @"YES" : @"NO", self.optional ? @"YES" : @"NO"];
}
@end
