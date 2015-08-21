//
// Created by lizhihui on 14/12/2.
// Copyright (c) 2014 lizhihui. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  An FileManager object  lets you manager the Calico's file hierarchical
 */
@interface FileManager : NSObject
///----------------------------
/// @name Accessing Application's Sandbox
///----------------------------
/*!
 *  Returns the current application's sandbox's `Application Support` Dictionary path
 *
 *  @return A string containning the sandbox path of Caches for the current application.
 */
+ (NSString *)pathForApplicationSupportDirectory;

/*!
 *  Returns the sandbox's Caches path for the current application.
 *
 *  @return A string containning the sandbox path of Caches for the current application.
 */
+ (NSString *)pathForCachesDirectory;

/*!
 *  Returns the sandbox's Document path for the current application.
 *
 *  @return A string containning the sandbox path of Document for the current application.
 */
+ (NSString *)pathForDocumentsDirectory;

/*!
 *  Returns the sandbox's Library path for the current application.
 *
 *  @return A string containning the sandbox path of Library for the current application.
 */
+ (NSString *)pathForLibraryDirectory;

/*!
 *  Returns the full pathname of the bundle’s subdirectory containing resources.
 *
 *  @return A string containing the path of current application bundle's local Path
 */
+ (NSString *)pathForMainBundleDirectory;

/*!
 *  Returns the path of the temporary directory for the current user.
 *
 *  @return A string containing the path of the temporary directory for the current user. If no such directory is currently available, returns nil.
 */
+ (NSString *)pathForTemporaryDirectory;
@end