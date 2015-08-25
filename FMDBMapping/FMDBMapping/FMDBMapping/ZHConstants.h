//
//  ZHConstants.h
//  FMDBMapping
//
//  Created by 李智慧 on 8/25/15.
//  Copyright (c) 2015 lizhihui. All rights reserved.
//

#ifndef FMDBMapping_ZHConstants_h
#define FMDBMapping_ZHConstants_h
//TODO:  change the commit
typedef NS_ENUM(int32_t, ZHPropertyType) {
    ////////////////////////////////
    // Primitive types
    ////////////////////////////////
    
    /** Integer type: NSInteger, int, long, Int (Swift) */
    ZHPropertyTypeInt    = 0,
    /** Boolean type: BOOL, bool, Bool (Swift) */
    ZHPropertyTypeBool   = 1,
    /** Float type: CGFloat (32bit), float, Float (Swift) */
    ZHPropertyTypeFloat  = 9,
    /** Double type: CGFloat (64bit), double, Double (Swift) */
    ZHPropertyTypeDouble = 10,
    
    ////////////////////////////////
    // Object types
    ////////////////////////////////
    
    /** String type: NSString, String (Swift) */
    ZHPropertyTypeString = 2,
    /** Data type: NSData */
    ZHPropertyTypeData   = 4,
    /** Any type: id, **not supported in Swift** */
    ZHPropertyTypeAny    = 6,
    /** Date type: NSDate */
    ZHPropertyTypeDate   = 7,
    
    ////////////////////////////////
    // Array/Linked object types
    ////////////////////////////////
    
    /** Object type. See [Realm Models](http://realm.io/docs/cocoa/latest/#models) */
    ZHPropertyTypeObject = 12,
    /** Array type. See [Realm Models](http://realm.io/docs/cocoa/latest/#models) */
    ZHPropertyTypeArray  = 13,
};

#endif
