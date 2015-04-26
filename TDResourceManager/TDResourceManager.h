//
//  TDResourceManager.h
//  TDResourceManager
//
//  Created by Robin Hsu on 2015/4/25.
//  Copyright (c) 2015年 TechD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TDUtilities.h"


//  ------------------------------------------------------------------------------------------------
#pragma mark declare enumeration.
//  ------------------------------------------------------------------------------------------------
typedef NS_ENUM( NSInteger, TDResourceManageSourceType ) {
    TDResourceManageSourceTypeDefault           = 0,    // in resource path
    TDResourceManageSourceTypeInAssetsBundle,
    TDResourceManageSourceTypeInZipped,
};


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------

@interface TDResourceManager : NSObject

//  ------------------------------------------------------------------------------------------------

//  ------------------------------------------------------------------------------------------------
#pragma mark property of variable.
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
#pragma mark declare for create the object.
//  ------------------------------------------------------------------------------------------------
// Returns the default singleton instance.
+ (instancetype) defaultManager;

//  ------------------------------------------------------------------------------------------------
- ( BOOL ) initEnvironment:(TDGetPathDirectory)directory;

- ( BOOL ) initAssetBundleEnvironment:(NSString *)bundleName with:(Class)aClass;

- ( BOOL ) initAssetBundleEnvironment:(NSString *)bundleName with:(Class)aClass forLocalization:(NSString *)localizationName;

- ( BOOL ) initZippedEnvironment:(NSString *)filename forDirectories:(TDGetPathDirectory) directory inDirectory:(NSString *)subpath
                    inZippedPath:(NSString *)prefix with:(NSString *)password;


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
- ( NSData * ) data:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath;

- ( NSData * ) data:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath fromData:(TDResourceManageSourceType)sourceType;


- ( UIImage * ) image:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath;

- ( UIImage * ) image:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath fromData:(TDResourceManageSourceType)sourceType;


- ( NSMutableDictionary * ) JSON:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath encoding:(NSStringEncoding)encode;

- ( NSMutableDictionary * ) JSON:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath encoding:(NSStringEncoding)encode
     fromData:(TDResourceManageSourceType)sourceType;


//  ------------------------------------------------------------------------------------------------

@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------





