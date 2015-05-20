//
//  TDConfigureData.m
//  TDResourceManager
//
//  Created by Robin Hsu on 2015/5/20.
//  Copyright (c) 2015年 TechD. All rights reserved.
//
//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


#ifndef __ARCMacros_H__
    #import "ARCMacros.h"
#endif  //  End of __ARCMacros_H__.

#import "Foundation+TechD.h"
#import "TDConfigureData.h"


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark class TDConfigureData

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark declare private category ()
//  ------------------------------------------------------------------------------------------------
@interface TDConfigureData ()
{
    /**
     *  prefix path name in zipped file.
     */
    NSString                      * prefixDirectory;
    
    /**
     *  the container of configure data.
     */
    //NSMutableDictionary           * configureData;      //  json struct.
    NSMutableArray                * configureData;      //  json struct.
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
@interface TDConfigureData (Private)

//  ------------------------------------------------------------------------------------------------
#pragma mark declare for initial this class.
//  ------------------------------------------------------------------------------------------------
/**
 *  @brief initial the attributes of class.
 *  initial the attributes of class.
 */
- ( void ) _InitAttributes;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief get a zipped file's full path with check the state of update.
 *  get a zipped file's full path with check the state of update.
 *
 *  @param filename                 zipped file name (without Extension part).
 *  @param directory                enumeration for directory.
 *  @param subpath                  resource's sub directory name of configure
 *  @param updateFile               pointer of extensioin result of method, to express file exist is update or default.
 *
 *  @return full path|nil           the file's full path or nil.
 */
+ ( NSString *) _GetZippedFileFullPath:(NSString *)filename forDirectories:(TDGetPathDirectory) directory inDirectory:(NSString *)subpath
                              isUpdate:(BOOL *)updateFile;

//  ------------------------------------------------------------------------------------------------
#pragma mark declare for json data.
//  ------------------------------------------------------------------------------------------------
/**
 *  @brief get a configure json data from unzipped object.
 *  get a configure json data from unzipped object.
 *
 *  @param filename                 configure file name (without Extension part).
 *  @param rootKey                  key of root of configure file.
 *  @param updateKey                key for update data.
 *
 *  @return YES|NO                  method success or failure.
 */
- ( BOOL ) _GetConfigureJsonData:(NSString *)filename configure:(NSString *)rootKey with:(NSString *)updateKey;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief parse the structure of json data.
 *  parse the structure of json data, and assign to container of configure data.
 *
 *  @param json                     the container of json data.
 *  @param rootKey                  key of root of configure file.
 *  @param updateKey                key for update data.
 *
 *  @return YES|NO                  method success or failure.
 */
- ( BOOL ) _ParseJsonStruct:(NSMutableDictionary *)json configure:(NSString *)rootKey with:(NSString *)updateKey;

//  ------------------------------------------------------------------------------------------------
#pragma mark declare for i/o properties.
//  ------------------------------------------------------------------------------------------------
/**
 *  @brief get the prefix path name in zipped file.
 *  get the prefix path name in zipped file.
 *
 *  @return prefix|nil              the prefix path name or nil
 */
- ( NSString * ) _GetPrefixDirectory;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief set a prefix path name in zipped file.
 *  set a prefix path name in zipped file.
 *
 *  @param prefix                   a prefix path name.
 */
- ( void ) _SetPrefixDirectory:(NSString *)prefix;

//  ------------------------------------------------------------------------------------------------

@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark implementation private category (Private)
//  ------------------------------------------------------------------------------------------------
@implementation TDConfigureData (Private)

//  ------------------------------------------------------------------------------------------------
#pragma mark method for initial this class.
//  ------------------------------------------------------------------------------------------------
- ( void ) _InitAttributes
{
    prefixDirectory                 = nil;

    configureData                   = nil;
    
}

//  ------------------------------------------------------------------------------------------------
+ ( NSString *) _GetZippedFileFullPath:(NSString *)filename forDirectories:(TDGetPathDirectory) directory inDirectory:(NSString *)subpath
                              isUpdate:(BOOL *)updateFile
{
    NSString                      * zipFileExtension;
    NSArray                       * fileSeparated;
    
    zipFileExtension                = @"zip";
    fileSeparated                   = [filename componentsSeparatedByString: @"."];
    //  check file name for appended timpstamp.
    if ( ( [fileSeparated count] >= 2 ) && ( [[filename pathExtension] isNumeric] == YES ) )
    {
        if ( NULL != updateFile )
        {
            *updateFile             = YES;
        }
        zipFileExtension            = nil;
    }
    return TDGetPathForDirectories( directory, filename, zipFileExtension, subpath, YES );
}

//  ------------------------------------------------------------------------------------------------
#pragma mark method for json data.
//  ------------------------------------------------------------------------------------------------
- ( BOOL ) _GetConfigureJsonData:(NSString *)filename configure:(NSString *)rootKey with:(NSString *)updateKey
{
    if ( nil == filename )
    {
        return NO;
    }
    
    NSString                      * key;
    NSDictionary                  * json;
    NSError                       * jsonParsingError;
    
    json                            = nil;
    jsonParsingError                = nil;
    key                             = [NSString stringWithFormat: @"%s/%s.json", [prefixDirectory UTF8String], [filename UTF8String]];
    json                            = [self JSON: filename ofType: @"json" inDirectory: prefixDirectory encoding: NSUTF8StringEncoding];
    if ( nil == json )
    {
        if ( nil != jsonParsingError )
        {
            NSLog( @"%@", jsonParsingError );
        }
        return NO;
    }
    
    if ( [self _ParseJsonStruct: (NSMutableDictionary *)json configure: rootKey with: updateKey] == NO )
    {
        NSLog( @"parse json warning." );
        return NO;
    }
    
    //  after get the configure, remove the data from container. (for release memory.)
    [[self                          unzipDataContainer] removeObjectForKey: key];
    
    SAFE_ARC_RELEASE( json );
    json                            = nil;
    
    return YES;
}

//  ------------------------------------------------------------------------------------------------
- ( BOOL ) _ParseJsonStruct:(NSMutableDictionary *)json configure:(NSString *)rootKey with:(NSString *)updateKey
{
    if ( ( nil == json ) || ( nil == rootKey ) )
    {
        return NO;
    }
    
    NSDictionary                  * tabData;
    
    tabData                         = [json objectForKey: rootKey];
    if ( nil == tabData )
    {
        return NO;
    }
    
    if ( nil == configureData )
    {
        //configureData                   = [[NSMutableDictionary alloc] initWithDictionary: tabData copyItems: YES];
        configureData               = [[NSMutableArray alloc] initWithArray: (NSArray *)tabData];
        return YES;
    }
    
    
    id                              idData;
    NSMutableArray                * removeObject;
    
    //  compare object when new data's key is equal older.
    if ( ( nil != updateKey ) && ( [updateKey length] != 0 ) )
    {
        removeObject                = [[NSMutableArray alloc] initWithCapacity: [configureData count]];
        for ( int i = 0; i < [configureData count]; ++i )
        {
            for ( NSDictionary * infoData in tabData )
            {
                if ( nil == infoData )
                {
                    continue;
                }
                
                //  compare.
                idData              = [configureData objectAtIndex:i];
                if ( ( nil == idData ) || ( [idData isKindOfClass: [NSDictionary class]] == NO ) || ( [idData objectForKey: updateKey] == nil ) || ( [infoData objectForKey: updateKey] == nil ) )
                {
                    continue;
                }
                if ( [[[configureData objectAtIndex:i] objectForKey: updateKey] isEqualToString: [infoData objectForKey: updateKey]] == NO )
                {
                    continue;
                }
                [removeObject       addObject: [configureData objectAtIndex:i]];
            }
        }
    }
    
    //  remove from contaner on here.
    if ( nil != removeObject )
    {
        for ( int i = 0; i < [removeObject count]; ++i )
        {
            [configureData          removeObject: [removeObject objectAtIndex: i]];
        }
    }
    
    //  replace all data.
    if ( ( ( nil == updateKey ) || ( [updateKey length] == 0 ) ) && ( ( [configureData count] != 0 ) && ( [tabData count] != 0 ) ) )
    {
        [configureData              removeAllObjects];
    }
    
    //  finish, insert into container.
    //[configureData                  addEntriesFromDictionary: tabData];
    [configureData                  addObjectsFromArray: (NSArray *)tabData];
    
    
    if ( nil != removeObject )
    {
        SAFE_ARC_RELEASE( removeObject );
        removeObject                = nil;
    }
    
    return YES;
}

//  ------------------------------------------------------------------------------------------------
#pragma mark method for i/o properties.
//  ------------------------------------------------------------------------------------------------
- ( NSString * ) _GetPrefixDirectory
{
    return prefixDirectory;
}

//  ------------------------------------------------------------------------------------------------
- ( void ) _SetPrefixDirectory:(NSString *)prefix
{
    prefixDirectory                 = prefix;
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
@implementation TDConfigureData

//  ------------------------------------------------------------------------------------------------
#pragma mark synthesize variable.

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark overwrite implementation of NSObject
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
    if ( nil == prefixDirectory )
    {
        SAFE_ARC_ASSIGN_POINTER_NIL( prefixDirectory );
    }
    
    if ( nil != configureData )
    {
        [configureData              removeAllObjects];
        SAFE_ARC_RELEASE( configureData );
        configureData               = nil;
    }
    
    SAFE_ARC_SUPER_DEALLOC();
}

//  ------------------------------------------------------------------------------------------------
#pragma mark method for create the object.
//  ------------------------------------------------------------------------------------------------
//  * override this parent method for create a singleton object.
+ (instancetype) defaultManager
{
    static TDConfigureData        * _defaultManager = nil;
    static dispatch_once_t          oneToken;
    
    dispatch_once( &oneToken, ^
    {
        _defaultManager             = [[self alloc] init];
    });
    return _defaultManager;
}

//  ------------------------------------------------------------------------------------------------
+ ( instancetype ) loadConfigureData:(NSString *)filename with:(NSString *)rootKey
                                from:(NSString *)zippedFilename forDirectories:(TDGetPathDirectory) directory inDirectory:(NSString *)subpath
                        inZippedPath:(NSString *)prefix with:(NSString *)password onSingleton:(BOOL)singleton
{
    NSParameterAssert( nil != filename );
    NSParameterAssert( nil != zippedFilename );
    
    TDConfigureData               * configureData;
    BOOL                            isUpdate;
    NSString                      * filePath;
    
    isUpdate                        = NO;
    filePath                        = [[self class] _GetZippedFileFullPath: zippedFilename forDirectories: directory inDirectory: subpath isUpdate: &isUpdate];
    if ( nil == filePath )
    {
        NSLog( @"file %s no exist.", [filePath UTF8String] );
        return NO;
    }
    
    configureData                   = [[self class] zippedFileEnvironment: filePath with: password onSingleton: singleton];
    if ( nil == configureData )
    {
        return nil;
    }
    
    if ( YES == isUpdate )
    {
        filename                    = [filename stringByDeletingPathExtension];
    }
    
    [configureData                  _SetPrefixDirectory: ( ( nil == prefix ) ? @"" : prefix ) ];
    if ( [configureData _GetConfigureJsonData: filename configure: rootKey with: nil] == NO )
    {
        NSLog( @"get configure data has warning. ");
        return configureData;
    }
    
    return configureData;
}

//  ------------------------------------------------------------------------------------------------
+ ( instancetype ) loadConfigureData:(NSString *)filename with:(NSString *)rootKey
                                from:(NSString *)zippedFullPath
                        inZippedPath:(NSString *)prefix with:(NSString *)password onSingleton:(BOOL)singleton;
{
    NSParameterAssert( nil != filename );
    NSParameterAssert( nil != zippedFullPath );
    
    TDConfigureData               * configureData;
    
//    NSString                      * filename;
    NSArray                       * fileSeparated;
    
//    filename                        = [fullPath lastPathComponent];
    fileSeparated                   = [[filename lastPathComponent] componentsSeparatedByString: @"."];
    if ( ( [fileSeparated count] >= 2 ) && ( [[filename pathExtension] isNumeric] == YES ) )
    {
        filename                    = [filename stringByDeletingPathExtension];
    }
    
    configureData                   = [[self class] zippedFileEnvironment: zippedFullPath with: password onSingleton: singleton];
    if ( nil == configureData )
    {
        return nil;
    }
    
    [configureData                  _SetPrefixDirectory: ( ( nil == prefix ) ? @"" : prefix ) ];
    if ( [configureData _GetConfigureJsonData: filename configure: rootKey with: nil] == NO )
    {
        NSLog( @"get configure data has warning. ");
        return configureData;
    }
    
    return configureData;
}

//  --------------------------------
//  ------------------------------------------------------------------------------------------------
- ( BOOL ) updateConfigureData:(NSString *)filename with:(NSString *)rootKey and:(NSString *)updateKey
                          from:(NSString *)zippedFilename forDirectories:(TDGetPathDirectory) directory inDirectory:(NSString *)subpath
                  inZippedPath:(NSString *)prefix with:(NSString *)password
{
    NSParameterAssert( nil != filename );
    NSParameterAssert( nil != zippedFilename );

    BOOL                            isUpdate;
    NSString                      * filePath;
    
    isUpdate                        = NO;
    filePath                        = [[self class] _GetZippedFileFullPath: zippedFilename forDirectories: directory inDirectory: subpath isUpdate: &isUpdate];
    if ( nil == filePath )
    {
        NSLog( @"file %s no exist.", [filePath UTF8String] );
        return NO;
    }
    
    if ( [self updateZippedFileContainer: filePath with: password] == NO )
    {
        NSLog( @"update zipped file container failed." );
        return NO;
    }
    [self                           _SetPrefixDirectory: ( ( nil == prefix ) ? @"" : prefix ) ];
    
    if ( YES == isUpdate )
    {
        filename                    = [filename stringByDeletingPathExtension];
    }
    
    if ( [self _GetConfigureJsonData: filename configure: rootKey with: updateKey] == NO )
    {
        NSLog( @"get configure data has warning. ");
        return NO;
    }
    
    return YES;
}

//  ------------------------------------------------------------------------------------------------
#pragma mark method for get data container.
//  ------------------------------------------------------------------------------------------------
- ( NSMutableArray *) configureData
{
    return configureData;
}

//  ------------------------------------------------------------------------------------------------

@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------














