//
//  TDResourceManager.m
//  TDResourceManager
//
//  Created by Robin Hsu on 2015/4/25.
//  Copyright (c) 2015年 TechD. All rights reserved.
//
//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------



#import "TDResourceManager.h"
#import "Foundation+TechD.h"


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
    NSString                      * assetLocalizationName;
    NSBundle                      * assetBundle;
    
    
    //  zipped.
    NSMutableDictionary           * unzipDataContainer;
    
    
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
    assetLocalizationName           = nil;
    assetBundle                     = nil;
    
    
    //  zipped.
    unzipDataContainer              = nil;
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
- ( NSString * ) _GetResourcePath:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath
{
    NSParameterAssert( nil != name );
    
    NSString                      * fullPath;
    
    fullPath                        = nil;
    currentSourceType               = sourceType;
    switch ( currentSourceType )
    {
        case TDResourceManageSourceTypeDefault:
        {
            fullPath                = TDGetPathForDirectories( defaultResourceDirectory, name, ext, subpath, YES );
            break;
        }
        case TDResourceManageSourceTypeInAssetsBundle:
        {
            fullPath                = [assetBundle pathForResource: name ofType: ext inDirectory: subpath forLocalization: assetLocalizationName];
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
    NSData
    
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
- ( BOOL ) initEnvironment:(TDGetPathDirectory)directory
{
    defaultResourceDirectory        = directory;
    
    //  ... set flag default to yes.
    return YES;
}

//  ------------------------------------------------------------------------------------------------
- ( BOOL ) initAssetBundleEnvironment:(NSString *)bundleName with:(Class)aClass
{
    return [self initAssetBundleEnvironment: bundleName with: aClass forLocalization: nil];
}

//  ------------------------------------------------------------------------------------------------
- ( BOOL ) initAssetBundleEnvironment:(NSString *)bundleName with:(Class)aClass forLocalization:(NSString *)localizationName
{
    NSParameterAssert( nil != bundleName );
    NSParameterAssert( nil != aClass );
    
    assetBundle                     = [NSBundle assetBundle: bundleName with: aClass];
    if ( nil == assetBundle )
    {
        return NO;
    }
    
    assetLocalizationName           = localizationName;
    //  ... set flag asset bundle to yes.
    return YES;
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
- ( NSMutableDictionary * ) JSON:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath fromData:(TDResourceManageSourceType)sourceType
     encoding:(NSStringEncoding)encode
{
    NSParameterAssert( nil != name );
    
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
                NSLog( @"load JSON error :%@", &error );
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

@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------









