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
@interface TDConfigureData : TDResourceManager

//  ------------------------------------------------------------------------------------------------
#pragma mark property of variable.
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
#pragma mark declare for create the object.
//  ------------------------------------------------------------------------------------------------
+ ( instancetype ) loadConfigureData:(NSString *)filename with:(NSString *)rootKey
                                from:(NSString *)zippedFilename forDirectories:(TDGetPathDirectory) directory inDirectory:(NSString *)subpath
                        inZippedPath:(NSString *)prefix with:(NSString *)password onSingleton:(BOOL)singleton;


//  ------------------------------------------------------------------------------------------------
+ ( instancetype ) loadConfigureData:(NSString *)filename with:(NSString *)rootKey
                                from:(NSString *)zippedFullPath
                        inZippedPath:(NSString *)prefix with:(NSString *)password onSingleton:(BOOL)singleton;

//  ------------------------------------------------------------------------------------------------
- ( BOOL ) updateConfigureData:(NSString *)filename with:(NSString *)rootKey and:(NSString *)updateKey
                          from:(NSString *)zippedFilename forDirectories:(TDGetPathDirectory) directory inDirectory:(NSString *)subpath
                  inZippedPath:(NSString *)prefix with:(NSString *)password;


//  ------------------------------------------------------------------------------------------------
#pragma mark declare for get data container.
//  ------------------------------------------------------------------------------------------------
- ( NSMutableArray *) configureData;

//  ------------------------------------------------------------------------------------------------


@end


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


