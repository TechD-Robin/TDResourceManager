//
//  TDResourceManager.h
//  TDResourceManager
//
//  Created by Robin Hsu on 2015/4/25.
//  Copyright (c) 2015年 TechD. All rights reserved.
//
//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TDUtilities.h"


#define TD_UNSTABLE_DEVELOPING      DEBUG


//  ------------------------------------------------------------------------------------------------
#pragma mark declare enumeration.
//  ------------------------------------------------------------------------------------------------
/**
 *  enumeration for resource manager's source type.
 */
typedef NS_ENUM( NSInteger, TDResourceManageSourceType ){
    /**
     *  resource type is defulat. ( in file system )
     */
    TDResourceManageSourceTypeDefault           = 0,
    /**
     *  resource type is assets bundle. ( in assets bundle )
     */
    // in resource path
    TDResourceManageSourceTypeInAssetsBundle,
    /**
     *  resource type is zipped file. ( in zipped file )
     */
    TDResourceManageSourceTypeInZipped,
};


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
/**
 *  the Resource Manager provide the same method to get resources,
 *  can get resources from resourcePath(normal file system), assets bundle object and zipped file.
 */
@interface TDResourceManager : NSObject

//  ------------------------------------------------------------------------------------------------

//  ------------------------------------------------------------------------------------------------
#pragma mark property of variable.
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
#pragma mark declare for create the object.
//  ------------------------------------------------------------------------------------------------
- (instancetype)init NS_UNAVAILABLE;

//  ------------------------------------------------------------------------------------------------
// Returns the default singleton instance.
/**
 *  @brief create a singleton object of resource manager or get the created.
 *  create a singleton object of resource manager or get the created;
 *  when just use this method to create a manager object, the object will have not any type;
 *  well, this method usually call after other creator; that's easy to get the manager object by this method.
 *
 *  @return object|nil              manager object or nil.
 */
+ ( instancetype ) defaultManager;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief create a singleton object of resource manager object of default type.
 *  create a singleton object of resource manager object of default type.
 *
 *  @param directory                enumeration for directory.
 *
 *  @return object|nil              manager object or nil.
 */
+ ( instancetype ) defaultEnvironment:(TDGetPathDirectory)directory;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief create a singleton object of resource manager object of assets bundle type.
 *  create a singleton object of resource manager object of assets bundle type.
 *
 *  @param bundleName               a bundle name.
 *  @param aClass                   a class.(is view controller usually)
 *
 *  @return object|nil              manager object or nil.
 */
+ ( instancetype ) assetsBundleEnvironment:(NSString *)bundleName with:(Class)aClass;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief create a singleton object of resource manager object of assets bundle type for localization.
 *  create a singleton object of resource manager object of assets bundle type for localization.
 *
 *  @param bundleName               a bundle name.
 *  @param aClass                   a class.(is view controller usually)
 *  @param localizationName         a locale identifier string.
 *
 *  @return object|nil              manager object or nil.
 */
+ ( instancetype ) assetsBundleEnvironment:(NSString *)bundleName with:(Class)aClass forLocalization:(NSString *)localizationName;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief create a singleton object of resource manager object of zipped file type.
 *  create a singleton object of resource manager object of zipped file type.
 *
 *  @param fullPathName             zipped file name (full path).
 *  @param password                 password of zipped file.
 *
 *  @return object|nil              manager object or nil.
 */
+ ( instancetype ) zippedFileEnvironment:(NSString *)fullPathName with:(NSString *)password;


#ifdef TD_UNSTABLE_DEVELOPING
//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
- ( BOOL ) changeDirectory:(TDGetPathDirectory)directory;

- ( BOOL ) changeAssetsBundle:(NSString *)bundleName with:(Class)aClass;

- ( BOOL ) changeAssetsBundle:(NSString *)bundleName with:(Class)aClass forLocalization:(NSString *)localizationName;

- ( BOOL ) changeZippedFile:(NSString *)fullPathName with:(NSString *)password;

#endif


//  --------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark declare for get resource data.
//  ------------------------------------------------------------------------------------------------
/**
 *  @brief get a data object by resource manager.
 *  get a data object by resource manager.
 *
 *  @param name                     filename of data.
 *  @param ext                      extension of filename
 *  @param subpath                  sub path in directory.
 *
 *  @return data|nil                data object or nil.
 */
- ( NSData * ) data:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief get a data object by resource manager.
 *  get a data object by resource manager.
 *
 *  @param name                     filename of data.
 *  @param ext                      extension of filename
 *  @param subpath                  sub path in directory.
 *  @param sourceType               resource type.
 *
 *  @return data|nil                data object or nil.
 */
- ( NSData * ) data:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath fromData:(TDResourceManageSourceType)sourceType;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief get a image object form resource manager.
 *  a image object form resource manager.
 *
 *  @param name                     filename of image.
 *  @param ext                      extension of filename
 *  @param subpath                  sub path in directory.
 *
 *  @return image|nil               image object or nil.
 */
- ( UIImage * ) image:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief get a image object form resource manager.
 *  a image object form resource manager.
 *
 *  @param name                     filename of image.
 *  @param ext                      extension of filename
 *  @param subpath                  sub path in directory.
 *  @param sourceType               resource type.
 *
 *  @return image|nil               image object or nil.
 */
- ( UIImage * ) image:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath fromData:(TDResourceManageSourceType)sourceType;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief get a JSON data by resource manager.
 *  get a JSON data by resource manager, the data container is an NSArray or NSDictionary.
 *
 *  @param name                     filename of JSON data.
 *  @param ext                      extension of filename
 *  @param subpath                  sub path in directory.
 *  @param encode                   charset encode.
 *
 *  @return container|nil           a container object or nil.
 */
- ( id ) JSON:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath encoding:(NSStringEncoding)encode;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief get a JSON data by resource manager.
 *  get a JSON data by resource manager, the data container is an NSArray or NSDictionary.
 *
 *  @param name                     filename of JSON data.
 *  @param ext                      extension of filename
 *  @param subpath                  sub path in directory.
 *  @param encode                   charset encode.
 *  @param sourceType               resource type.
 *
 *  @return container|nil           a container object or nil.
 */
- ( id ) JSON:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath encoding:(NSStringEncoding)encode
     fromData:(TDResourceManageSourceType)sourceType;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief get a property list data by resource manager.
 *  get a property list data by resource manager.
 *
 *  @param name                     filename of plist data.
 *  @param ext                      extension of filename
 *  @param subpath                  sub path in directory.
 *  @param encode                   charset encode.
 *
 *  @return container|nil           a container object or nil.
 */
- ( NSMutableDictionary * ) propertyList:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath encoding:(NSStringEncoding)encode;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief get a property list data by resource manager.
 *  get a property list data by resource manager.
 *
 *  @param name                     filename of plist data.
 *  @param ext                      extension of filename
 *  @param subpath                  sub path in directory.
 *  @param encode                   charset encode.
 *  @param sourceType               resource type.
 *
 *  @return container|nil           a container object or nil.
 */
- ( NSMutableDictionary * ) propertyList:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath encoding:(NSStringEncoding)encode
                        fromData:(TDResourceManageSourceType)sourceType;

//  ------------------------------------------------------------------------------------------------
#pragma mark declare for assets bundle type.
//  ------------------------------------------------------------------------------------------------
/**
 *  @brief set the table name of localized string.
 *  set the table name of localized string.
 *
 *  @param tableName                table name of localized string.
 */
- ( void ) setLocalizedStringTable:(NSString *)tableName;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief get the localized string for key.
 *  get the localized string for key.
 *
 *  @param aKey                     a localized string's key.
 *
 *  @return string|nil              the localized string or nil.
 */
- ( NSString * ) localizedStringForKey:(NSString *)aKey;

//  ------------------------------------------------------------------------------------------------

@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------





