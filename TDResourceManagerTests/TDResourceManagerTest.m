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

//  ------------------------------------------------------------------------------------------------
- ( void ) testResourceManagerInvalidInit
{
    //  assets bundle.
    XCTAssertThrows( [TDResourceManager assetsBundleEnvironment: nil with: nil], @"Invalid init should throw" );
    XCTAssertThrows( [TDResourceManager assetsBundleEnvironment: nil with: nil forLocalization: nil], @"Invalid init should throw" );
    
    //  zipped.
    XCTAssertThrows( [TDResourceManager zippedFileEnvironment: nil with: nil], @"Invalid init should throw" );
}

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
    
    if ( [fileManager fileExistsAtPath: destinationPath] == YES )
    {
        return;
    }
    result                          = [fileManager copyItemAtPath: sourcePath toPath:destinationPath error: &error];
    XCTAssertNil( error, @"the result's error should be nil" );
    XCTAssertTrue( result, @"method's result should be true." );
}

//  ------------------------------------------------------------------------------------------------
- ( void ) getData:(NSString *)prefixDir
{
    //  get nsdata.
    NSString                      * subpath;
    NSData                        * data;
    UIImage                       * image;
    NSMutableDictionary           * jsonData;
    
    subpath                         = ( ( nil == prefixDir ) ? @"Resources" : [NSString stringWithFormat: @"%@/Resources", prefixDir] );
    XCTAssertNotNil( subpath, @"the sub path should not be nil" );
    data                            = [resourceManager data: @"README" ofType: @"md" inDirectory: subpath];
    XCTAssertNotNil( resourceManager, @"NSData object's data should not be nil" );
    
    //  get json data.
    jsonData                        = [resourceManager JSON: @"package" ofType: @"json" inDirectory: subpath encoding: NSUTF8StringEncoding];
    XCTAssertNotNil( jsonData, @"json object should not be nil" );
    
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
    NSMutableDictionary           * jsonData;
    
    subpath                         = ( ( nil == prefixDir ) ? @"Resources" : [NSString stringWithFormat: @"%@/Resources", prefixDir] );
    XCTAssertNotNil( subpath, @"the sub path should not be nil" );
    data                            = [resourceManager data: @"LICENSE" ofType: nil inDirectory: subpath fromData: sourceType];
    XCTAssertNotNil( data, @"data object should not be nil" );
    
    //  get json data.
    jsonData                        = [resourceManager JSON: @"bower" ofType: @"json" inDirectory: subpath encoding: NSUTF8StringEncoding fromData: sourceType];
    XCTAssertNotNil( jsonData, @"json object should not be nil" );
    
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
}

//  ------------------------------------------------------------------------------------------------
- ( void) testGetTypeAssetsBundleData
{
    resourceManager                 = [TDResourceManager assetsBundleEnvironment: @"Tester/JSQMATest.bundle" with: [self class] forLocalization: @"zh-Hant" ];
    //resourceManager                 = [TDResourceManager assetsBundleEnvironment: @"Tester/JSQMATest.bundle" with: [self class]];
    
    XCTAssertNotNil( resourceManager, @"Resource manager should not be nil" );
    
    //  get data
    [self                           getData: nil];
    [self                           getDataWith: TDResourceManageSourceTypeInAssetsBundle and: nil];
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


//  ------------------------------------------------------------------------------------------------
- ( void ) testRegularExpression
{
    BOOL                            result;
    NSString                      * regularExpress;
    NSString                      * testString;
    NSPredicate                   * predicate;
    
    result                          = NO;
    regularExpress                  = @"([^*|:\"<>?]|[ ]|\\w)+@[1-9][0-9]*[xX]$";
    predicate                       = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regularExpress];

    testString                      = @"@2x";
    result                          = [testString compareByRegularExpression: regularExpress];
    NSLog( @"comapre result : %d", result );

    testString                      = @"a@2x";
    result                          = [testString compareByRegularExpression: regularExpress];
    NSLog( @"comapre result : %d", result );
    
    testString                      = @"abc@2x";
    result                          = [testString compareByRegularExpression: regularExpress];
    NSLog( @"comapre result : %d", result );
    
    testString                      = @"@abc@2x";
    result                          = [testString compareByRegularExpression: regularExpress];
    NSLog( @"comapre result : %d", result );

    testString                      = @"@abc@2x ";
    result                          = [testString compareByRegularExpression: regularExpress];
    NSLog( @"comapre result : %d", result );

    
}


//  --------------------------------
//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------

@end
































