//
// Created by lizhihui on 14/12/2.
// Copyright (c) 2014 lizhihui. All rights reserved.
//

#import "FileManager.h"


@interface FileManager ()

+ (void)assertPath:(NSString *)aPath;
@end

@implementation FileManager

#pragma mark - CalicoFimeAccess


#pragma mark - SystemFileManager

#pragma mark AccessFile
///----------------------------
/// @name Query File
///----------------------------
+ (BOOL)itemExistsAtPath:(NSString *)aPath {
    return [[NSFileManager defaultManager] fileExistsAtPath:aPath];
}

#pragma mark Create
///----------------------------
/// @name Create File or Dictionary
///----------------------------
/*!
 *  Creates a directory with given attributes at the specified path.
 *
 *  @param aPath  A path string identifying the directory to create.
 *  You may specify a full path or a path that is relative to the current working directory.
 *  This parameter must not be nil.
 *  @param pError On input, a pointer to an error object.
 *  If an error occurs, this pointer is set to an actual error object containing the error information.
 *  You may specify nil for this parameter if you do not want the error information.
 *
 *  @return YES if the directory was created, YES if createIntermediates is set and the directory already exists), or NO if an error occurred.
 */
+ (BOOL)createDictionaryAtPath:(NSString *)aPath error:(NSError **)pError {
    [FileManager assertPath:aPath];
    return [[NSFileManager defaultManager] createDirectoryAtPath:aPath withIntermediateDirectories:YES attributes:nil error:pError];
}

/*!
 *  Creates a file with the specified content and attributes at the given location.
 *
 *  @param aPath The path for the new file.
 *  @param data  A data object containing the contents of the new file.
 *
 *  @return YES if the operation was successful or if the item already exists, otherwise NO.
 */
+ (BOOL)createFileAtPath:(NSString *)aPath data:(NSData *)data {
    [FileManager assertPath:aPath];
    return [[NSFileManager defaultManager] createFileAtPath:aPath contents:data attributes:nil];
}

#pragma mark Delete
///----------------------------
/// @name Remove File or Dictionary
///----------------------------
/*!
 *  Removes the file or directory at the specified path.
 *
 *  @param aPath A path string indicating the file or directory to remove. If the path specifies a directory, the contents of that directory are recursively removed. You may specify nil for this parameter.
 *  @param error On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 *
 *  @return YES if the item was removed successfully or if path was nil. Returns NO if an error occurred. If the delegate aborts the operation for a file, this method returns YES. However, if the delegate aborts the operation for a directory, this method returns NO.
 */
+ (BOOL)removeItemAtPath:(NSString *)aPath error:(NSError **)error {
    [FileManager assertPath:aPath];
    return [[NSFileManager defaultManager] removeItemAtPath:aPath error:error];
}


+ (NSString *)pathForApplicationSupportDirectory {
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        path = [paths lastObject];
    });
    return path;
}


+ (NSString *)pathForCachesDirectory {
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        path = [paths lastObject];
    });
    return path;
}


+ (NSString *)pathForDocumentsDirectory {
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [paths lastObject];
    });
    return path;
}


+ (NSString *)pathForLibraryDirectory {
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        path = [paths lastObject];
    });
    return path;
}

+ (NSString *)pathForMainBundleDirectory {
    return [NSBundle mainBundle].resourcePath;
}


+ (NSString *)pathForTemporaryDirectory {
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        path = NSTemporaryDirectory();
    });
    return path;
}

#pragma mark - Asserts

/*!
 *  Assert the specified path not nil or equal to @""
 *
 *  @param aPath the path to Assert
 */
+ (void)assertPath:(NSString *)aPath {
    NSAssert(aPath != nil, @"Invalid path. Path cannot be nil.");
    NSAssert(![aPath isEqualToString:@""], @"Invalid path. Path cannot be empty string.");
}

@end