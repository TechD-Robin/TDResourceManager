//
//  TDConfigureData.h
//  TDResourceManager
//
//  Created by Robin Hsu on 2015/5/20.
//  Copyright (c) 2015年 TechD. All rights reserved.
//
//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "TDResourceManager.h"

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
/**
 *  a data object it's inherit from Resource Manager.
 *  extension function for loaded configure data into a container.
 */
@interface TDConfigureData : TDResourceManager

//  ------------------------------------------------------------------------------------------------
#pragma mark property of variable.
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
#pragma mark declare for create the object.
//  ------------------------------------------------------------------------------------------------
/**
 *  @brief create a Configure Data object and loaded configure data from default environment into a container.
 *  create a Configure Data object and loaded configure data from default environment into a container.
 *
 *  @param filename                 a filename of configure data.
 *  @param rootKey                  key of root of configure file.
 *  @param defaultDirectory         enumeration for directory.
 *  @param subpath                  sub path in directory.
 *  @param singleton                create a singleton object or normal object.
 *
 *  @return object|nil              data(with resource manager) object or nil.
 */
+ ( instancetype ) loadConfigureData:(NSString *)filename with:(NSString *)rootKey encoding:(NSStringEncoding)encode
                                from:(TDGetPathDirectory)defaultDirectory inDirectory:(NSString *)subpath onSingleton:(BOOL)singleton;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief create a Configure Data object and loaded configure data from zipped file into a container.
 *  create a Configure Data object and loaded configure data from zipped file into a container.
 *
 *  @param filename                 a filename of configure data.
 *  @param rootKey                  key of root of configure file.
 *  @param zippedFilename           zipped file name (without Extension part).
 *  @param directory                enumeration for directory.
 *  @param subpath                  resource's sub directory name of configure
 *  @param prefix                   prefix path name in zipped file.
 *  @param password                 password of zipped file.
 *  @param singleton                create a singleton object or normal object.
 *
 *  @return object|nil              data(with resource manager) object or nil.
 */
+ ( instancetype ) loadConfigureData:(NSString *)filename with:(NSString *)rootKey encoding:(NSStringEncoding)encode
                                from:(NSString *)zippedFilename forDirectories:(TDGetPathDirectory)directory inDirectory:(NSString *)subpath
                        inZippedPath:(NSString *)prefix with:(NSString *)password onSingleton:(BOOL)singleton;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief create a Configure Data object and loaded configure data from zipped file into a container.
 *  create a Configure Data object and loaded configure data from zipped file into a container.
 *
 *  @param filename                 a filename of configure data.
 *  @param rootKey                  key of root of configure file.
 *  @param zippedFullPath           zipped file name (full path).
 *  @param prefix                   prefix path name in zipped file.
 *  @param password                 password of zipped file.
 *  @param singleton                create a singleton object or normal object.
 *
 *  @return object|nil              data(with resource manager) object or nil.
 */
+ ( instancetype ) loadConfigureData:(NSString *)filename with:(NSString *)rootKey encoding:(NSStringEncoding)encode
                                from:(NSString *)zippedFullPath
                        inZippedPath:(NSString *)prefix with:(NSString *)password onSingleton:(BOOL)singleton;


//  ------------------------------------------------------------------------------------------------
/**
 *  @brief change environment and update configure data.
 *  change environment and update configure data.
 *
 *  @param filename                 a filename of configure data.
 *  @param rootKey                  key of root of configure file.
 *  @param updateKey                key for update data.
 *  @param defaultDirectory         enumeration for directory.
 *  @param subpath                  sub path in directory.
 *
 *  @return YES|NO                  method success or failure.
 */
- ( BOOL ) updateConfigureData:(NSString *)filename with:(NSString *)rootKey and:(NSString *)updateKey encoding:(NSStringEncoding)encode
                          from:(TDGetPathDirectory)defaultDirectory inDirectory:(NSString *)subpath;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief update data for the Configure Data object and configure data.
 *  update data for the Configure Data object and configure data.
 *
 *  @param filename                 a filename of update's configure data.
 *  @param rootKey                  key of root of configure file.
 *  @param updateKey                key for update data.
 *  @param zippedFilename           zipped file name (without Extension part).
 *  @param directory                enumeration for directory.
 *  @param subpath                  resource's sub directory name of configure
 *  @param prefix                   prefix path name in zipped file.
 *  @param password                 password of zipped file.
 *
 *  @return YES|NO                  method success or failure.
 */
- ( BOOL ) updateConfigureData:(NSString *)filename with:(NSString *)rootKey and:(NSString *)updateKey encoding:(NSStringEncoding)encode
                          from:(NSString *)zippedFilename forDirectories:(TDGetPathDirectory) directory inDirectory:(NSString *)subpath
                  inZippedPath:(NSString *)prefix with:(NSString *)password;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief update data for the Configure Data object and configure data.
 *  update data for the Configure Data object and configure data.
 *
 *  @param filename                 a filename of update's configure data.
 *  @param rootKey                  key of root of configure file.
 *  @param updateKey                key for update data.
 *  @param zippedFullPath           zipped file name (full path).
 *  @param prefix                   prefix path name in zipped file.
 *  @param password                 password of zipped file.
 *
 *  @return YES|NO                  method success or failure.
 */
- ( BOOL ) updateConfigureData:(NSString *)filename with:(NSString *)rootKey and:(NSString *)updateKey encoding:(NSStringEncoding)encode
                          from:(NSString *)zippedFullPath
                  inZippedPath:(NSString *)prefix with:(NSString *)password;


//  ------------------------------------------------------------------------------------------------
//  --------------------------------



//  ------------------------------------------------------------------------------------------------
#pragma mark declare for get data container.
//  ------------------------------------------------------------------------------------------------
/**
 *  @brief get the container of configure data.
 *  the container of configure data.
 *
 *  @return container|nil           the container or nil.
 */
- ( NSMutableArray *) configureData;

//  ------------------------------------------------------------------------------------------------


@end


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


