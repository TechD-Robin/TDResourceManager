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
    XCTAssertNotNil( sourcePath, @"the bundle's path should not b nil" );
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

//  --------------------------------
//  ------------------------------------------------------------------------------------------------
- ( void ) createDefault
{
    [self                           copyResourceData];
    
    //  default.
    resourceManager                  = [TDResourceManager defaultEnvironment: TDTemporaryDirectory];
    XCTAssertNotNil( resourceManager, @"Resource manager should not be nil" );
}

//  ------------------------------------------------------------------------------------------------
- ( void ) testGetTypeDefaultData
{
    [self                           createDefault];
    //  get nsdata .
    NSData                        * data;
    UIImage                       * image;
    NSMutableDictionary           * jsonData;
    
    data                            = [resourceManager data: @"README" ofType: @"md" inDirectory: @"Tester/Resources"];
    XCTAssertNotNil( resourceManager, @"NSData object's data should not be nil" );
    
    data                            = [resourceManager data: @"Readme" ofType: @"txt" inDirectory: @"Tester/Resources"
                                                   fromData: TDResourceManageSourceTypeDefault];
    XCTAssertNotNil( data, @"data object should not be nil" );
    
    image                           = [resourceManager image: @"ic_file_download_black_36dp@1x" ofType: @"png" inDirectory: @"Tester/Resources/Images"];
    XCTAssertNotNil( image, @"image object should not be nil" );
    
    image                           = [resourceManager image: @"ic_file_download_grey600_36dp@2x" ofType: @"png" inDirectory: @"Tester/Resources/Images"
                                                    fromData: TDResourceManageSourceTypeDefault];
    XCTAssertNotNil( image, @"image object should not be nil" );
    
    jsonData                        = [resourceManager JSON: @"package" ofType: @"json" inDirectory: @"Tester/Resources" encoding: NSUTF8StringEncoding];
    XCTAssertNotNil( jsonData, @"json object should not be nil" );
    
    jsonData                        = [resourceManager JSON: @"bower" ofType: @"json" inDirectory: @"Tester/Resources" encoding: NSUTF8StringEncoding
                                                   fromData: TDResourceManageSourceTypeDefault];
    XCTAssertNotNil( jsonData, @"json object should not be nil" );
}



//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


@end
































