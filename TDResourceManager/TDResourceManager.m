//
//  TDResourceManager.m
//  TDResourceManager
//
//  Created by Robin Hsu on 2015/4/25.
//  Copyright (c) 2015年 TechD. All rights reserved.
//
//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


#ifndef __ARCMacros_H__
    #import "ARCMacros.h"
#endif  //  End of __ARCMacros_H__.

#import "TDResourceManager.h"
#import "Foundation+TechD.h"
#import "ZipArchive.h"


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark class TDResourceManager

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark declare private category ()
//  ------------------------------------------------------------------------------------------------
//  --------------------------------
@interface TDResourceManager ()
{
    TDResourceManageSourceType      currentSourceType;
    
    //  default.
    TDGetPathDirectory              defaultResourceDirectory;
    
    //  asset bundle.
    NSString                      * localizedStringTableName;
    NSString                      * assetLocalizationName;
    NSBundle                      * assetsBundle;
    

    //  zipped.
    NSMutableDictionary           * unzipDataContainer;
    
    
    /**
     *  flags of state.
     */
    struct {
        unsigned int                initiatedDefault:1;
        unsigned int                initiatedAssetsBundle:1;
        unsigned int                initiatedInZipped:1;
        
    } stateFlags;

}

//  ------------------------------------------------------------------------------------------------

@end


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark declare private category (Private)
//  ------------------------------------------------------------------------------------------------
@interface TDResourceManager (Private)

//  ------------------------------------------------------------------------------------------------
#pragma mark declare for initial this class.
//  ------------------------------------------------------------------------------------------------
/**
 *  @brief initial the attributes of class.
 *  initial the attributes of class.
 */
- ( void ) _InitAttributes;

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
- ( BOOL ) _CheckInitiatedState:(TDResourceManageSourceType)sourceType;

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
- ( BOOL ) _UnzipFile:(NSString *)fullPath with:(NSString *)password;


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
- ( NSString * ) _GetResourcePath:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath;

//  ------------------------------------------------------------------------------------------------


@end


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark implementation private category (Private)
//  ------------------------------------------------------------------------------------------------
@implementation TDResourceManager (Private)

//  ------------------------------------------------------------------------------------------------
#pragma mark method for initial this class.
//  ------------------------------------------------------------------------------------------------
//  --------------------------------
- ( void ) _InitAttributes
{
    currentSourceType               = TDResourceManageSourceTypeDefault;
    
    //  default.
    defaultResourceDirectory        = TDHomeDirectory;
    
    
    //  asset bundle.
    localizedStringTableName        = nil;
    assetLocalizationName           = nil;
    assetsBundle                    = nil;
    
    
    //  zipped.
    unzipDataContainer              = nil;
    
    
    //  flags of state.
    stateFlags.initiatedDefault     = NO;
    stateFlags.initiatedAssetsBundle= NO;
    stateFlags.initiatedInZipped    = NO;
    
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
- ( BOOL ) _CheckInitiatedState:(TDResourceManageSourceType)sourceType
{
    switch ( sourceType )
    {
        case TDResourceManageSourceTypeDefault:
        {
            return (BOOL)stateFlags.initiatedDefault;
        }
        case TDResourceManageSourceTypeInAssetsBundle:
        {
            return (BOOL)stateFlags.initiatedAssetsBundle;
        }
        case TDResourceManageSourceTypeInZipped:
        {
            return (BOOL)stateFlags.initiatedInZipped;
        }
        default:
            break;
    }
    return NO;
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
- ( BOOL ) _UnzipFile:(NSString *)fullPath with:(NSString *)password
{
    NSParameterAssert( fullPath );
    
    BOOL                            result;
    ZipArchive                    * zip;
    NSDictionary                  * unzipData;
    
    result                          = NO;
    unzipData                       = nil;
    zip                             = [[ZipArchive alloc] init];
    NSParameterAssert( nil != zip );
    
    if ( nil == password )
    {
        result                      = [zip UnzipOpenFile: fullPath];
    }
    else
    {
        result                      = [zip UnzipOpenFile: fullPath Password: password];
    }
    
    if ( result == NO )
    {
        NSLog( @"cannot open zip file %s.", __FUNCTION__ );
        [zip                        UnzipCloseFile];
        return NO;
    }
    
    unzipData                       = [zip UnzipFileToMemory];
    if ( nil == unzipData )
    {
        NSLog( @"cannot unzip file to memory");
        [zip                        UnzipCloseFile];
        return NO;
    }
    
    if ( nil == unzipDataContainer )
    {
        unzipDataContainer          = [[NSMutableDictionary alloc] initWithDictionary: unzipData copyItems: YES];
    }
    else
    {
        [unzipDataContainer         addEntriesFromDictionary: unzipData];
    }
    
    
    [zip                            UnzipCloseFile];
    
    SAFE_ARC_RELEASE( unzipData );
    unzipData                       = nil;
    
    
    SAFE_ARC_RELEASE( zip );
    zip                             = nil;
    return YES;
}



//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
- ( NSString * ) _GetResourcePath:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath
{
    NSParameterAssert( nil != name );
    
    NSString                      * fullPath;
    
    fullPath                        = nil;
    switch ( currentSourceType )
    {
        case TDResourceManageSourceTypeDefault:
        {
            fullPath                = TDGetPathForDirectories( defaultResourceDirectory, name, ext, subpath, YES );
            break;
        }
        case TDResourceManageSourceTypeInAssetsBundle:
        {
            fullPath                = [assetsBundle pathForResource: name ofType: ext inDirectory: subpath forLocalization: assetLocalizationName];
            break;
        }
        case TDResourceManageSourceTypeInZipped:
        {
            if ( nil != ext )
            {
                fullPath            = [name stringByAppendingPathExtension: ext];
            }
            if ( nil != subpath )
            {
                fullPath            = [subpath stringByAppendingPathComponent: fullPath];
            }
            break;
        }
        default:
            break;
    }
    return fullPath;
}


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------

@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark implementation for public
//  ------------------------------------------------------------------------------------------------
@implementation TDResourceManager


//  ------------------------------------------------------------------------------------------------
#pragma mark synthesize variable.

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark overwrite implementation of NSObject.
//  ------------------------------------------------------------------------------------------------
- ( instancetype ) init
{
    self                            = [super init];
    if ( nil == self )
    {
        return nil;
    }
    
    [self                           _InitAttributes];
    return self;
}

//  ------------------------------------------------------------------------------------------------
- ( void ) dealloc
{
    
}

//  ------------------------------------------------------------------------------------------------
#pragma mark method for create the object.
//  ------------------------------------------------------------------------------------------------
//  --------------------------------
+ (instancetype) defaultManager
{
    static TDResourceManager      * _defaultManager = nil;
    static dispatch_once_t          oneToken;
    
    dispatch_once( &oneToken, ^
    {
        _defaultManager             = [[self alloc] init];
    });
    
    return _defaultManager;
}

//  ------------------------------------------------------------------------------------------------
- ( BOOL ) initDefaultEnvironment:(TDGetPathDirectory)directory
{
    defaultResourceDirectory        = directory;
    
    //  ... set flag default to yes.
    stateFlags.initiatedDefault     = YES;
    return YES;
}

//  ------------------------------------------------------------------------------------------------
+ ( instancetype ) defaultEnvironment:(TDGetPathDirectory)directory
{
    TDResourceManager             * manager;
    
    manager                         = [TDResourceManager defaultManager];
    NSParameterAssert( nil != manager );
    
    if ( [manager initDefaultEnvironment: directory] == NO )
    {
        return nil;
    }
    return manager;
}

//  ------------------------------------------------------------------------------------------------
- ( BOOL ) initAssetsBundleEnvironment:(NSString *)bundleName with:(Class)aClass forLocalization:(NSString *)localizationName
{
    NSParameterAssert( nil != bundleName );
    NSParameterAssert( nil != aClass );
    
    assetsBundle                    = [NSBundle assetBundle: bundleName with: aClass];
    NSParameterAssert( nil != assetsBundle );
    
    assetLocalizationName           = localizationName;
    stateFlags.initiatedAssetsBundle= YES;
    return YES;
}

//  ------------------------------------------------------------------------------------------------
+ ( instancetype ) assetsBundleEnvironment:(NSString *)bundleName with:(Class)aClass
{
    return [[self class] assetsBundleEnvironment: bundleName with: aClass forLocalization: nil];
}

//  ------------------------------------------------------------------------------------------------
+ ( instancetype ) assetsBundleEnvironment:(NSString *)bundleName with:(Class)aClass forLocalization:(NSString *)localizationName
{
    TDResourceManager             * manager;
    
    manager                         = [TDResourceManager defaultManager];
    NSParameterAssert( nil != manager );
    if ( [manager initAssetsBundleEnvironment: bundleName with: aClass forLocalization: localizationName] == NO )
    {
        return nil;
    }
    return manager;
}

//  ------------------------------------------------------------------------------------------------
- ( BOOL ) initZippedFileEnvironment:(NSString *)fullPathName with:(NSString *)password
{
    NSParameterAssert( nil != fullPathName );
    
    BOOL                            result;
    
    result                          = NO;
    result                          = [self _UnzipFile: fullPathName with: password];
    if ( NO == result )
    {
        return NO;
    }
    stateFlags.initiatedInZipped    = YES;
    return YES;
}

//  ------------------------------------------------------------------------------------------------
+ ( instancetype ) zippedFileEnvironment:(NSString *)fullPathName with:(NSString *)password
{
    TDResourceManager             * manager;
    
    manager                         = [TDResourceManager defaultManager];
    NSParameterAssert( nil != manager );
    if ( [manager initZippedFileEnvironment: fullPathName with: password] == NO )
    {
        return nil;
    }
    return manager;
}


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
- ( BOOL ) changeDirectory:(TDGetPathDirectory)directory
{
    if ( YES == stateFlags.initiatedDefault )
    {
        stateFlags.initiatedDefault = NO;
    }
    return [self initDefaultEnvironment: directory];
}

//  ------------------------------------------------------------------------------------------------
- ( BOOL ) changeAssetsBundle:(NSString *)bundleName with:(Class)aClass
{
    return [self changeAssetsBundle: bundleName with: aClass forLocalization: nil];
}

//  ------------------------------------------------------------------------------------------------
- ( BOOL ) changeAssetsBundle:(NSString *)bundleName with:(Class)aClass forLocalization:(NSString *)localizationName
{
    if ( YES == stateFlags.initiatedAssetsBundle )
    {
        if ( nil != assetsBundle )
        {
            SAFE_ARC_RELEASE( assetsBundle )
            assetsBundle            = nil;
        }
        stateFlags.initiatedAssetsBundle = NO;
    }
    return [self initAssetsBundleEnvironment: bundleName with: aClass forLocalization: localizationName];
}

//  ------------------------------------------------------------------------------------------------
- ( BOOL ) changeZippedFile:(NSString *)fullPathName with:(NSString *)password
{
    if ( YES == stateFlags.initiatedInZipped )
    {
        if ( nil != unzipDataContainer )
        {
            [unzipDataContainer     removeAllObjects];
            SAFE_ARC_RELEASE( unzipDataContainer );
            unzipDataContainer      = nil;
        }
        stateFlags.initiatedInZipped= NO;
    }
    return [self initZippedFileEnvironment: fullPathName with: password];
}



//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
- ( NSData * ) data:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath
{
    return [self data: name ofType: ext inDirectory: subpath fromData: currentSourceType];
}

//  ------------------------------------------------------------------------------------------------
- ( NSData * ) data:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath fromData:(TDResourceManageSourceType)sourceType
{
    NSParameterAssert( nil != name );
    NSParameterAssert( YES == [self _CheckInitiatedState: sourceType] );
    
    NSData                        * data;
    NSString                      * fullPath;
    
    data                            = nil;
    currentSourceType               = sourceType;
    fullPath                        = [self _GetResourcePath: name ofType: ext inDirectory: subpath];
    NSParameterAssert( nil != fullPath );
    
    switch ( sourceType )
    {
        case TDResourceManageSourceTypeDefault:
        case TDResourceManageSourceTypeInAssetsBundle:
        {
            data                    = [NSData dataWithContentsOfFile: fullPath];
            break;
        }
        case TDResourceManageSourceTypeInZipped:
        {
            data                    = [unzipDataContainer objectForKey: fullPath];
            break;
        }
        default:
            break;
    }
    return data;
}

//  ------------------------------------------------------------------------------------------------
- ( UIImage * ) image:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath
{
    return [self image: name ofType: ext inDirectory: subpath fromData: currentSourceType];
}

//  ------------------------------------------------------------------------------------------------
- ( UIImage * ) image:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath fromData:(TDResourceManageSourceType)sourceType
{
    NSParameterAssert( nil != name );
    NSParameterAssert( YES == [self _CheckInitiatedState: sourceType] );
    
    UIImage                       * image;
    NSString                      * fullPath;
    
    image                           = nil;
    currentSourceType               = sourceType;
    fullPath                        = [self _GetResourcePath: name ofType: ext inDirectory: subpath];
    NSParameterAssert( nil != fullPath );
    
    switch ( sourceType )
    {
        case TDResourceManageSourceTypeDefault:
        case TDResourceManageSourceTypeInAssetsBundle:
        {
            image                   = [UIImage imageWithContentsOfFile: fullPath];
            break;
        }
        case TDResourceManageSourceTypeInZipped:
        {
            NSData                * data;
            
            data                    = [unzipDataContainer objectForKey: fullPath];
            if ( nil == data )
            {
                return nil;
            }
            image                   = [UIImage imageWithData: data];
            break;
        }
        default:
            break;
    }
    return image;
}

//  ------------------------------------------------------------------------------------------------
- ( NSMutableDictionary * ) JSON:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath encoding:(NSStringEncoding)encode
{
    return [self JSON: name ofType: ext inDirectory: subpath encoding: encode fromData: currentSourceType];
}

//  ------------------------------------------------------------------------------------------------
- ( NSMutableDictionary * ) JSON:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath encoding:(NSStringEncoding)encode
                        fromData:(TDResourceManageSourceType)sourceType
{
    NSParameterAssert( nil != name );
    NSParameterAssert( YES == [self _CheckInitiatedState: sourceType] );
    
    NSMutableDictionary           * jsonContainer;
    NSError                       * error;
    NSString                      * fullPath;
    
    error                           = nil;
    jsonContainer                   = nil;
    currentSourceType               = sourceType;
    fullPath                        = [self _GetResourcePath: name ofType: ext inDirectory: subpath];
    NSParameterAssert( nil != fullPath );
    
    switch ( sourceType )
    {
        case TDResourceManageSourceTypeDefault:
        case TDResourceManageSourceTypeInAssetsBundle:
        {
            
            jsonContainer           = [NSJSONSerialization loadJSON: fullPath encoding: encode error: &error];
            if ( nil != error )
            {
                NSLog( @"load JSON error :%@", error );
                return nil;
            }
            break;
        }
        case TDResourceManageSourceTypeInZipped:
        {
            NSData                * data;
            
            data                    = [unzipDataContainer objectForKey: fullPath];
            if ( nil == data )
            {
                return nil;
            }
            jsonContainer           = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
            break;
        }
        default:
            break;
    }
    return jsonContainer;
    
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
- ( void ) setLocalizedStringTable:(NSString *)tableName
{
    NSParameterAssert( YES == stateFlags.initiatedAssetsBundle );
    NSParameterAssert( nil != assetsBundle );
    NSParameterAssert( nil != tableName );
    localizedStringTableName        = tableName;
    return;
}

//  ------------------------------------------------------------------------------------------------
- ( NSString * ) localizedStringForKey:(NSString *)aKey
{
    NSParameterAssert( nil != aKey );
    NSParameterAssert( YES == stateFlags.initiatedAssetsBundle );
    NSParameterAssert( nil != assetsBundle );
    NSParameterAssert( nil != localizedStringTableName );
    return NSLocalizedStringFromTableInBundle( aKey,  localizedStringTableName, assetsBundle,  nil );
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------

@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------









