//
//  TDResourceManagerTest.m
//  TDResourceManager
//
//  Created by Robin Hsu on 2015/4/29.
//  Copyright (c) 2015年 TechD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TDResourceManager.h"
#import "Foundation+TechD.h"

@interface TDResourceManagerTest : XCTestCase
{
    TDResourceManager             * resourceManager;
}

@end

@implementation TDResourceManagerTest

//  ------------------------------------------------------------------------------------------------
- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
}

//  ------------------------------------------------------------------------------------------------
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    
    resourceManager                 = nil;
    
    
    [super tearDown];
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
- ( void ) testDefaultManagerInit
{
    TDResourceManager             * defaultManager;
    
    defaultManager                  = [TDResourceManager defaultManager];
    XCTAssertNotNil( defaultManager, @"Resource manager should not be nil" );
}

//  ------------------------------------------------------------------------------------------------
- ( void ) testResourceManagerInit
{
    TDResourceManager             * defaultManager;
    
    //  default.
    defaultManager                  = [TDResourceManager defaultEnvironment: TDResourcesDirectory];
    XCTAssertNotNil( defaultManager, @"Resource manager should not be nil" );
    
    //  assets bundle.
    defaultManager                  = [TDResourceManager assetsBundleEnvironment: @"Tester/JSQMATest.bundle" with: [self class]];
    XCTAssertNotNil( defaultManager, @"Resource manager should not be nil" );
    
    defaultManager                  = [TDResourceManager assetsBundleEnvironment: @"Tester/JSQMATest.bundle" with: [self class] forLocalization: @"zh-Hant" ];
    XCTAssertNotNil( defaultManager, @"Resource manager should not be nil" );
    
    //  zipped.
    NSString                      * fullPath;
    NSBundle                      * bundle;
    NSString                      * bundleResourcePath;
    
    bundle                          = [NSBundle bundleForClass: [self class]];
    XCTAssertNotNil( bundle, @"the bundle should not b nil" );
    bundleResourcePath              = [bundle resourcePath];
    XCTAssertNotNil( bundleResourcePath, @"the bundle's path should not b nil" );
    
    fullPath                        = [bundleResourcePath stringByAppendingPathComponent: @"Tester/Resources.zip"];
    XCTAssertNotNil( fullPath, @"the bundle's path should not b nil" );
    defaultManager                  = [TDResourceManager zippedFileEnvironment: fullPath with: nil];
    XCTAssertNotNil( defaultManager, @"Resource manager should not be nil" );

    fullPath                        = [bundleResourcePath stringByAppendingPathComponent: @"Tester/ResourcesPasswd.zip"];
    defaultManager                  = [TDResourceManager zippedFileEnvironment: fullPath with: @"tester"];
    XCTAssertNotNil( defaultManager, @"Resource manager should not be nil" );
}

#ifdef DEBUG
//  ------------------------------------------------------------------------------------------------
- ( void ) testResourceManagerInvalidInit
{
    //  assets bundle.
    XCTAssertThrows( [TDResourceManager assetsBundleEnvironment: nil with: nil], @"Invalid init should throw" );
    //XCTAssertThrows( [TDResourceManager assetsBundleEnvironment: nil with: nil forLocalization: nil], @"Invalid init should throw" );
    XCTAssertThrows( [TDResourceManager assetsBundleEnvironment: nil with: nil], @"Invalid init should throw" );
    
    //  zipped.
    XCTAssertThrows( [TDResourceManager zippedFileEnvironment: nil with: nil], @"Invalid init should throw" );
}

#endif
//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
- ( void ) copyResourceData;
{
    //  copy resource data to destination.
    //  because this tester class cannot get the resource path at App Target, when use method [[NSBundle ...] resourcePath].
    NSString                      * sourcePath;
    NSString                      * destinationPath;
    NSBundle                      * bundle;
    NSString                      * bundleResourcePath;
    NSFileManager                 * fileManager;
    
    //  data source.
    fileManager                     = [NSFileManager defaultManager];
    bundle                          = [NSBundle bundleForClass: [self class]];
    XCTAssertNotNil( bundle, @"the bundle should not b nil" );
    bundleResourcePath              = [bundle resourcePath];
    XCTAssertNotNil( bundleResourcePath, @"the bundle's path should not b nil" );
    
    sourcePath                      = [bundleResourcePath stringByAppendingPathComponent: @"Tester"];
    XCTAssertNotNil( sourcePath, @"the bundle's path should not be nil" );
    XCTAssertTrue( [fileManager fileExistsAtPath: sourcePath], @"method's result should be true." );
    
    //  data destination.
    destinationPath                 = NSTemporaryDirectory();
    XCTAssertNotNil( destinationPath, @"the bundle's path should not b nil" );
    destinationPath                 = [destinationPath stringByAppendingString: @"Tester"];
    XCTAssertNotNil( destinationPath, @"the bundle's path should not b nil" );
    
    BOOL                            result;
    NSError                       * error;
    
    if ( [fileManager fileExistsAtPath: destinationPath] == NO )
    {
        result                      = [fileManager copyItemAtPath: sourcePath toPath:destinationPath error: &error];
        XCTAssertNil( error, @"the result's error should be nil" );
        XCTAssertTrue( result, @"method's result should be true." );
    }
    
    //  copy data for change setting.
    //  for default type.
    //  data source.
    sourcePath                      = [bundleResourcePath stringByAppendingPathComponent: @"Tester/Resources"];
    XCTAssertNotNil( sourcePath, @"the bundle's path should not be nil" );
    XCTAssertTrue( [fileManager fileExistsAtPath: sourcePath], @"method's result should be true." );
    
    //  data destination.
    destinationPath                 = TDGetPathForDirectories( TDDocumentDirectory, @"ResourcesCopy", nil, @"Tester", NO );
    XCTAssertNotNil( destinationPath, @"the bundle's path should not b nil" );
    
    result                          = NO;
    error                           = nil;
    if ( [fileManager fileExistsAtPath: destinationPath] == NO )
    {
        result                      = [fileManager copyItemAtPath: sourcePath toPath:destinationPath error: &error];
        XCTAssertNil( error, @"the result's error should be nil" );
        XCTAssertTrue( result, @"method's result should be true." );
    }

    
    //  for assets bundle type.
    //  data source.
    sourcePath                      = [bundleResourcePath stringByAppendingPathComponent: @"Tester/JSQMATest.bundle"];
    XCTAssertNotNil( sourcePath, @"the bundle's path should not be nil" );
    XCTAssertTrue( [fileManager fileExistsAtPath: sourcePath], @"method's result should be true." );
    
    //  data destination.
//    destinationPath                 = TDGetPathForDirectories( TDDocumentDirectory, @"JSQMACopy", @"bundle", @"Tester", NO );
    destinationPath                 = [bundleResourcePath stringByAppendingPathComponent: @"Tester/JSQMACopy.bundle"];
    XCTAssertNotNil( destinationPath, @"the bundle's path should not b nil" );
    
    result                          = NO;
    error                           = nil;
    if ( [fileManager fileExistsAtPath: destinationPath] == NO )
    {
        result                      = [fileManager copyItemAtPath: sourcePath toPath:destinationPath error: &error];
        XCTAssertNil( error, @"the result's error should be nil" );
        XCTAssertTrue( result, @"method's result should be true." );
    }
    
    
    //  for zipped file type.
    //  data source.
    sourcePath                      = [bundleResourcePath stringByAppendingPathComponent: @"Tester/Resources.zip"];
    XCTAssertNotNil( sourcePath, @"the bundle's path should not be nil" );
    XCTAssertTrue( [fileManager fileExistsAtPath: sourcePath], @"method's result should be true." );
    
    //  data destination.
    destinationPath                 = TDGetPathForDirectories( TDDocumentDirectory, @"ResourcesCopy", @"zip", @"Tester",  NO );
    XCTAssertNotNil( destinationPath, @"the bundle's path should not b nil" );
    
    result                          = NO;
    error                           = nil;
    if ( [fileManager fileExistsAtPath: destinationPath] == NO )
    {
        result                      = [fileManager copyItemAtPath: sourcePath toPath:destinationPath error: &error];
        XCTAssertNil( error, @"the result's error should be nil" );
        XCTAssertTrue( result, @"method's result should be true." );
    }
}

//  ------------------------------------------------------------------------------------------------
- ( void ) getData:(NSString *)prefixDir
{
    //  get nsdata.
    NSString                      * subpath;
    NSData                        * data;
    UIImage                       * image;
    id                              container;
    
    subpath                         = ( ( nil == prefixDir ) ? @"Resources" : [NSString stringWithFormat: @"%@/Resources", prefixDir] );
    XCTAssertNotNil( subpath, @"the sub path should not be nil" );
    data                            = [resourceManager data: @"README" ofType: @"md" inDirectory: subpath];
    XCTAssertNotNil( data, @"NSData object's data should not be nil" );
    
    //  get json data.
    container                       = [resourceManager JSON: @"package" ofType: @"json" inDirectory: subpath encoding: NSUTF8StringEncoding];
    XCTAssertNotNil( container, @"json object should not be nil" );
    
    //  get plist data.
    container                       = [resourceManager propertyList: @"LINDA's Cats" ofType: @"plist" inDirectory: subpath encoding: NSUTF8StringEncoding];
    XCTAssertNotNil( container, @"property list object should not be nil" );
    
    //  get xml data.
//    container                       = [resourceManager propertyList: @"cd_catalog" ofType: @"xml" inDirectory: subpath encoding: NSUTF8StringEncoding];
//    XCTAssertNotNil( container, @"xml object should not be nil" );
    
//    data                            = [resourceManager data: @"cd_catalog" ofType: @"xml" inDirectory: subpath];
//    XCTAssertNotNil( container, @"XML object should not be nil" );
//    
//    NSPropertyListFormat            format;
//    NSError                       * error;
//    
////    NSXMLParser
//    
//    error                           = nil;
//    container                       = [NSPropertyListSerialization propertyListWithData: data options: NSPropertyListMutableContainersAndLeaves
//                                                                                 format: &format error: &error];
    
    
    //  get image.
    subpath                         = ( ( nil == prefixDir ) ? @"Resources/Images" : [NSString stringWithFormat: @"%@/Resources/Images", prefixDir] );
    XCTAssertNotNil( subpath, @"the sub path should not be nil" );
    image                           = [resourceManager image: @"ic_file_download_black_36dp@1x" ofType: @"png" inDirectory: subpath];
    XCTAssertNotNil( image, @"image object should not be nil" );
    
    
    image                           = [resourceManager image: @"ic_file_download_grey600_36dp@2x" ofType: @"png" inDirectory: subpath];
    XCTAssertNotNil( image, @"image object should not be nil" );
    
    image                           = [resourceManager image: @"ic_file_download_grey600_36dp" ofType: @"png" inDirectory: subpath];
    XCTAssertNotNil( image, @"image object should not be nil" );
    
    image                           = [resourceManager image: @"ic_file_download_grey600_36dp" ofType: nil inDirectory: subpath];
    XCTAssertNotNil( image, @"image object should not be nil" );
    
    image                           = [resourceManager image: @"ic_file_download_grey600_36dp@1x" ofType: nil inDirectory: subpath];
    XCTAssertNotNil( image, @"image object should not be nil" );
    
    
}

//  ------------------------------------------------------------------------------------------------
- ( void ) getDataWith:(TDResourceManageSourceType)sourceType and:(NSString *)prefixDir
{
    //  get nsdata.
    NSString                      * subpath;
    NSData                        * data;
    UIImage                       * image;
    id                              container;
    
    subpath                         = ( ( nil == prefixDir ) ? @"Resources" : [NSString stringWithFormat: @"%@/Resources", prefixDir] );
    XCTAssertNotNil( subpath, @"the sub path should not be nil" );
    data                            = [resourceManager data: @"LICENSE" ofType: nil inDirectory: subpath fromData: sourceType];
    XCTAssertNotNil( data, @"data object should not be nil" );
    
    //  get json data.
    container                       = [resourceManager JSON: @"bower" ofType: @"json" inDirectory: subpath encoding: NSUTF8StringEncoding fromData: sourceType];
    XCTAssertNotNil( container, @"json object should not be nil" );
    
    //  get plist data.
    container                       = [resourceManager propertyList: @"LINDA's Cats" ofType: @"plist" inDirectory: subpath encoding: NSUTF8StringEncoding fromData: sourceType];
    XCTAssertNotNil( container, @"property list object should not be nil" );
    
    //  get image.
    subpath                         = ( ( nil == prefixDir ) ? @"Resources/Images" : [NSString stringWithFormat: @"%@/Resources/Images", prefixDir] );
    XCTAssertNotNil( subpath, @"the sub path should not be nil" );
    image                           = [resourceManager image: @"ic_file_download_grey600_36dp@2x" ofType: @"png" inDirectory: subpath fromData: sourceType];
    XCTAssertNotNil( image, @"image object should not be nil" );
}

//  ------------------------------------------------------------------------------------------------
- ( void ) testGetTypeDefaultData
{
    [self                           copyResourceData];
    
    resourceManager                  = [TDResourceManager defaultEnvironment: TDTemporaryDirectory];
    XCTAssertNotNil( resourceManager, @"Resource manager should not be nil" );
    
    //  get data
    [self                           getData: @"Tester" ];
    [self                           getDataWith: TDResourceManageSourceTypeDefault and: @"Tester"];
    
    //  change directory
    [resourceManager                changeDirectory: TDDocumentDirectory];
    
    NSData                        * data;
    
    data                            = [resourceManager data: @"LICENSE" ofType: nil inDirectory: @"Tester/ResourcesCopy"];
    XCTAssertNotNil( data, @"NSData object's data should not be nil" );
    
}

//  ------------------------------------------------------------------------------------------------
- ( void) testGetTypeAssetsBundleData
{
    [self                           copyResourceData];
    
    //resourceManager                 = [TDResourceManager assetsBundleEnvironment: @"Tester/JSQMATest.bundle" with: [self class] forLocalization: @"zh-Hant" ];
    resourceManager                 = [TDResourceManager assetsBundleEnvironment: @"Tester/JSQMATest.bundle" with: [self class]];
    
    XCTAssertNotNil( resourceManager, @"Resource manager should not be nil" );
    
    //  get data
    [self                           getData: nil];
    [self                           getDataWith: TDResourceManageSourceTypeInAssetsBundle and: nil];
    
    //  localized string.
    [resourceManager                setLocalizedStringTable: @"JSQMessages"];
    XCTAssertNotNil( [resourceManager localizedStringForKey: @"new_message"] );
    XCTAssertNotEqualObjects( [resourceManager localizedStringForKey: @"new_message"], @"new_message");
    
    //  change assets bundle.
    XCTAssertTrue( [resourceManager changeAssetsBundle: @"Tester/JSQMACopy.bundle" with: [self class]], @"method's result should be true." );

    NSData                        * data;
    
    data                            = [resourceManager data: @"index" ofType: @"html" inDirectory: @"Resources"];
    XCTAssertNotNil( data, @"NSData object's data should not be nil" );
    
}

//  ------------------------------------------------------------------------------------------------
- ( void ) testGetTypeZippedData
{
    //  zipped.
    NSString                      * fullPath;
    NSBundle                      * bundle;
    NSString                      * bundleResourcePath;
    
    bundle                          = [NSBundle bundleForClass: [self class]];
    XCTAssertNotNil( bundle, @"the bundle should not b nil" );
    bundleResourcePath              = [bundle resourcePath];
    XCTAssertNotNil( bundleResourcePath, @"the bundle's path should not b nil" );
    
    fullPath                        = [bundleResourcePath stringByAppendingPathComponent: @"Tester/Resources.zip"];
    XCTAssertNotNil( fullPath, @"the bundle's path should not b nil" );
    resourceManager                 = [TDResourceManager zippedFileEnvironment: fullPath with: nil];
    
    XCTAssertNotNil( resourceManager, @"Resource manager should not be nil" );
    
    //  get data
    [self                           getData: nil];
    [self                           getDataWith: TDResourceManageSourceTypeInZipped and: nil];
    
    //  change zipped file.
    fullPath                        = TDGetPathForDirectories( TDDocumentDirectory, @"ResourcesCopy", @"zip", @"Tester",  YES );
    XCTAssertNotNil( fullPath, @"the bundle's path should not b nil" );
    XCTAssertTrue( [resourceManager changeZippedFile: fullPath with: nil], @"method's result should be true." );
    
    UIImage                        * image;
    
    image                           = [resourceManager image: @"ic_file_download_white_36dp" ofType: nil inDirectory: @"Resources/Images"];
    XCTAssertNotNil( image, @"image object should not be nil" );
}

//  ------------------------------------------------------------------------------------------------
- ( void ) testGetTypeZippedDataWithPassword
{
    //  zipped.
    NSString                      * fullPath;
    NSBundle                      * bundle;
    NSString                      * bundleResourcePath;
    
    bundle                          = [NSBundle bundleForClass: [self class]];
    XCTAssertNotNil( bundle, @"the bundle should not be nil" );
    bundleResourcePath              = [bundle resourcePath];
    XCTAssertNotNil( bundleResourcePath, @"the bundle's path should not b nil" );
    
    fullPath                        = [bundleResourcePath stringByAppendingPathComponent: @"Tester/ResourcesPasswd.zip"];
    XCTAssertNotNil( fullPath, @"the bundle's path should not b nil" );
    resourceManager                 = [TDResourceManager zippedFileEnvironment: fullPath with: @"tester"];
    
    XCTAssertNotNil( resourceManager, @"Resource manager should not be nil" );
    
    //  get data
    [self                           getData: nil];
    [self                           getDataWith: TDResourceManageSourceTypeInZipped and: nil];
}


//  --------------------------------
//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------

@end
































