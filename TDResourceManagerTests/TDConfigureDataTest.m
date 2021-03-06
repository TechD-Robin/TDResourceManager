//
//  TDConfigureDataTest.m
//  TDResourceManager
//
//  Created by Robin Hsu on 2015/5/20.
//  Copyright (c) 2015年 TechD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "TDConfigureData.h"

@interface TDConfigureDataTest : XCTestCase
{
    TDConfigureData               * configureData;
}

@end

//  ------------------------------------------------------------------------------------------------
@implementation TDConfigureDataTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

//  ------------------------------------------------------------------------------------------------
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    if ( nil != configureData )
    {
        configureData               = nil;
    }
    
    [super tearDown];
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
    
    if ( [fileManager fileExistsAtPath: destinationPath] == NO )
    {
        result                      = [fileManager copyItemAtPath: sourcePath toPath:destinationPath error: &error];
        XCTAssertNil( error, @"the result's error should be nil" );
        XCTAssertTrue( result, @"method's result should be true." );
    }
}

//  ------------------------------------------------------------------------------------------------
- ( void ) testGetConfigureFromDefault
{
    [self                           copyResourceData];
    
    configureData                   = [TDConfigureData loadConfigureData: @"StickerLibraryTabDefault"
                                                                    type: TDConfigureDataSourceFileTypeJSON encoding: NSUTF8StringEncoding
                                                                    withConfigure: @"Tab"
                                                                    from: TDTemporaryDirectory inDirectory: @"Tester/Resources" onSingleton: NO];
    XCTAssertNotNil( configureData, @"Resource manager should not be nil" );
    
    XCTAssertNotNil( [configureData configureData], @"configure Data container should not be nil" );
    NSLog( @"container : %@", [configureData configureData] );
    
    BOOL                            result;
    
    result                          = [configureData updateConfigureData: @"StickerLibraryTabUpdate"
                                                                    type: TDConfigureDataSourceFileTypeJSON encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab" and: @"Name"
                                                                    from: TDTemporaryDirectory inDirectory: @"Tester/Resources"];
    XCTAssertTrue( result, @"method's result should be true." );
    XCTAssertNotNil( [configureData configureData], @"configure Data container should not be nil" );
    NSLog( @"container : %@", [configureData configureData] );
    
}

//  ------------------------------------------------------------------------------------------------
- ( void ) testGetConfigureFromAssetsBundle
{
    [self                           copyResourceData];
    
    configureData                   = [TDConfigureData loadConfigureData: @"StickerLibraryTabDefault"
                                                                    type: TDConfigureDataSourceFileTypeJSON encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab"
                                                                    from: @"Tester/JSQMATest.bundle" with: [self class] inDirectory: @"Resources" onSingleton: NO];
    XCTAssertNotNil( configureData, @"Resource manager should not be nil" );
    
    XCTAssertNotNil( [configureData configureData], @"configure Data container should not be nil" );
    NSLog( @"container : %@", [configureData configureData] );
    
    BOOL                            result;
    
    result                          = [configureData updateConfigureData: @"StickerLibraryTabUpdate"
                                                                    type: TDConfigureDataSourceFileTypeJSON encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab" and: @"Name"
                                                                    from: @"Tester/JSQMATest.bundle" with: [self class] inDirectory: @"Resources"];
    XCTAssertTrue( result, @"method's result should be true." );
    XCTAssertNotNil( [configureData configureData], @"configure Data container should not be nil" );
    NSLog( @"container : %@", [configureData configureData] );
    
}

//  ------------------------------------------------------------------------------------------------
- ( void ) testGetConfigureFromZippedFullPath
{
    [self                           copyResourceData];
    
    //  zipped.
    NSString                      * fullPath;
    NSBundle                      * bundle;
    NSString                      * bundleResourcePath;
    
    bundle                          = [NSBundle bundleForClass: [self class]];
    XCTAssertNotNil( bundle, @"the bundle should not b nil" );
    bundleResourcePath              = [bundle resourcePath];
    XCTAssertNotNil( bundleResourcePath, @"the bundle's path should not b nil" );
    
    
    fullPath                        = [bundleResourcePath stringByAppendingPathComponent: @"Tester/Resources.zip"];
    configureData                   = [TDConfigureData loadConfigureData: @"StickerLibraryTabDefault"
                                                                    type: TDConfigureDataSourceFileTypeJSON encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab"
                                                                    from: fullPath inZippedPath: @"Resources" with: nil onSingleton: NO];
    XCTAssertNotNil( configureData, @"Resource manager should not be nil" );
    XCTAssertNotEqualObjects( configureData, [TDConfigureData defaultManager], @"both object should not be equaled" );
    
    configureData                   = [TDConfigureData loadConfigureData: @"StickerLibraryTabDefault"
                                                                    type: TDConfigureDataSourceFileTypeJSON encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab"
                                                                    from: fullPath inZippedPath: @"Resources" with: nil onSingleton: YES];
    XCTAssertNotNil( configureData, @"Resource manager should not be nil" );
    XCTAssertEqualObjects( configureData, [TDConfigureData defaultManager], @"both object should be equaled" );
    XCTAssertNotNil( [configureData configureData], @"configure Data container should not be nil" );
    NSLog( @"container : %@", [configureData configureData] );
    
}

//  ------------------------------------------------------------------------------------------------
- ( void ) testGetConfigureFromZipped
{
    [self                           copyResourceData];
    
    //  zipped.
    BOOL                            result;
    
    configureData                   = [TDConfigureData loadConfigureData: @"StickerLibraryTabDefault"
                                                                    type: TDConfigureDataSourceFileTypeJSON encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab"
                                                                    from: @"Resources" forDirectories: TDTemporaryDirectory inDirectory: @"Tester"
                                                            inZippedPath: @"Resources" with: nil onSingleton: NO];
    XCTAssertNotNil( configureData, @"Resource manager should not be nil" );
    XCTAssertNotEqualObjects( configureData, [TDConfigureData defaultManager], @"both object should not be equaled" );
    
    
    configureData                   = [TDConfigureData loadConfigureData: @"StickerLibraryTabDefault"
                                                                    type: TDConfigureDataSourceFileTypeJSON encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab"
                                                                    from: @"Resources" forDirectories: TDTemporaryDirectory inDirectory: @"Tester"
                                                            inZippedPath: @"Resources" with: nil onSingleton: YES];
    XCTAssertNotNil( configureData, @"Resource manager should not be nil" );
    XCTAssertEqualObjects( configureData, [TDConfigureData defaultManager], @"both object should be equaled" );
    XCTAssertNotNil( [configureData configureData], @"configure Data container should not be nil" );    
    NSLog( @"container : %@", [configureData configureData] );
    
    result                          = [configureData updateConfigureData: @"StickerLibraryTabUpdate"
                                                                    type: TDConfigureDataSourceFileTypeJSON encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab" and: @"Name"
                                                                    from: @"Resources.zip" forDirectories: TDTemporaryDirectory inDirectory: @"Tester"
                                                            inZippedPath: @"Resources" with: nil];
    XCTAssertTrue( result, @"method's result should be true." );
    XCTAssertNotNil( [configureData configureData], @"configure Data container should not be nil" );
    NSLog( @"container : %@", [configureData configureData] );
    
    NSString                      * fullPath;
    NSBundle                      * bundle;
    NSString                      * bundleResourcePath;
    
    bundle                          = [NSBundle bundleForClass: [self class]];
    XCTAssertNotNil( bundle, @"the bundle should not b nil" );
    bundleResourcePath              = [bundle resourcePath];
    XCTAssertNotNil( bundleResourcePath, @"the bundle's path should not b nil" );
    
    
    fullPath                        = [bundleResourcePath stringByAppendingPathComponent: @"Tester/Resources.zip"];
    result                          = [configureData updateConfigureData: @"StickerLibraryTabUpdate" type: TDConfigureDataSourceFileTypeJSON encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab" and: @"Name"
                                                                    from: fullPath inZippedPath: @"Resources" with: nil];
    XCTAssertTrue( result, @"method's result should be true." );
    
}

//  ------------------------------------------------------------------------------------------------
- ( void ) testGetConfigureFromDefaultWithPlist
{
    [self                           copyResourceData];
    
    configureData                   = [TDConfigureData loadConfigureData: @"StickerLibraryTabDefault"
                                                                    type: TDConfigureDataSourceFileTypePList encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab"
                                                                    from: TDTemporaryDirectory inDirectory: @"Tester/Resources" onSingleton: NO];
    XCTAssertNotNil( configureData, @"Resource manager should not be nil" );
    
    XCTAssertNotNil( [configureData configureData], @"configure Data container should not be nil" );
    NSLog( @"container : %@", [configureData configureData] );
    
    BOOL                            result;
    
    result                          = [configureData updateConfigureData: @"StickerLibraryTabUpdate"
                                                                    type: TDConfigureDataSourceFileTypePList encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab" and: @"Name"
                                                                    from: TDTemporaryDirectory inDirectory: @"Tester/Resources"];
    XCTAssertTrue( result, @"method's result should be true." );
    XCTAssertNotNil( [configureData configureData], @"configure Data container should not be nil" );
    NSLog( @"container : %@", [configureData configureData] );
}

//  ------------------------------------------------------------------------------------------------
- ( void ) testGetConfigureFromAssetsBundleWithPlist
{
    [self                           copyResourceData];
    
    configureData                   = [TDConfigureData loadConfigureData: @"StickerLibraryTabDefault"
                                                                    type: TDConfigureDataSourceFileTypePList encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab"
                                                                    from: @"Tester/JSQMATest.bundle" with: [self class] inDirectory: @"Resources" onSingleton: NO];
    XCTAssertNotNil( configureData, @"Resource manager should not be nil" );
    
    XCTAssertNotNil( [configureData configureData], @"configure Data container should not be nil" );
    NSLog( @"container : %@", [configureData configureData] );
    
    BOOL                            result;
    
    result                          = [configureData updateConfigureData: @"StickerLibraryTabUpdate"
                                                                    type: TDConfigureDataSourceFileTypePList encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab" and: @"Name"
                                                                    from: @"Tester/JSQMATest.bundle" with: [self class] inDirectory: @"Resources"];
    XCTAssertTrue( result, @"method's result should be true." );
    XCTAssertNotNil( [configureData configureData], @"configure Data container should not be nil" );
    NSLog( @"container : %@", [configureData configureData] );
    
}

//  ------------------------------------------------------------------------------------------------
- ( void ) testGetConfigureFromZippedFullPathWithPlist
{
    [self                           copyResourceData];
    
    //  zipped.
    NSString                      * fullPath;
    NSBundle                      * bundle;
    NSString                      * bundleResourcePath;
    
    bundle                          = [NSBundle bundleForClass: [self class]];
    XCTAssertNotNil( bundle, @"the bundle should not b nil" );
    bundleResourcePath              = [bundle resourcePath];
    XCTAssertNotNil( bundleResourcePath, @"the bundle's path should not b nil" );
    
    
    fullPath                        = [bundleResourcePath stringByAppendingPathComponent: @"Tester/Resources.zip"];
    configureData                   = [TDConfigureData loadConfigureData: @"StickerLibraryTabDefault"
                                                                    type: TDConfigureDataSourceFileTypePList encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab"
                                                                    from: fullPath inZippedPath: @"Resources" with: nil onSingleton: NO];
    XCTAssertNotNil( configureData, @"Resource manager should not be nil" );
    XCTAssertNotEqualObjects( configureData, [TDConfigureData defaultManager], @"both object should not be equaled" );
    
    configureData                   = [TDConfigureData loadConfigureData: @"StickerLibraryTabDefault"
                                                                    type: TDConfigureDataSourceFileTypePList encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab"
                                                                    from: fullPath inZippedPath: @"Resources" with: nil onSingleton: YES];
    XCTAssertNotNil( configureData, @"Resource manager should not be nil" );
    XCTAssertEqualObjects( configureData, [TDConfigureData defaultManager], @"both object should be equaled" );
    XCTAssertNotNil( [configureData configureData], @"configure Data container should not be nil" );
    NSLog( @"container : %@", [configureData configureData] );
    
}

//  ------------------------------------------------------------------------------------------------
- ( void ) testGetConfigureFromZippedWithPlist
{
    [self                           copyResourceData];
    
    //  zipped.
    BOOL                            result;
    
    configureData                   = [TDConfigureData loadConfigureData: @"StickerLibraryTabDefault"
                                                                    type: TDConfigureDataSourceFileTypePList encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab"
                                                                    from: @"Resources" forDirectories: TDTemporaryDirectory inDirectory: @"Tester"
                                                            inZippedPath: @"Resources" with: nil onSingleton: NO];
    XCTAssertNotNil( configureData, @"Resource manager should not be nil" );
    XCTAssertNotEqualObjects( configureData, [TDConfigureData defaultManager], @"both object should not be equaled" );
    
    
    configureData                   = [TDConfigureData loadConfigureData: @"StickerLibraryTabDefault"
                                                                    type: TDConfigureDataSourceFileTypePList encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab"
                                                                    from: @"Resources" forDirectories: TDTemporaryDirectory inDirectory: @"Tester"
                                                            inZippedPath: @"Resources" with: nil onSingleton: YES];
    XCTAssertNotNil( configureData, @"Resource manager should not be nil" );
    XCTAssertEqualObjects( configureData, [TDConfigureData defaultManager], @"both object should be equaled" );
    XCTAssertNotNil( [configureData configureData], @"configure Data container should not be nil" );
    NSLog( @"container : %@", [configureData configureData] );
    
    result                          = [configureData updateConfigureData: @"StickerLibraryTabUpdate"
                                                                    type: TDConfigureDataSourceFileTypePList encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab" and: @"Name"
                                                                    from: @"Resources.zip" forDirectories: TDTemporaryDirectory inDirectory: @"Tester"
                                                            inZippedPath: @"Resources" with: nil];
    XCTAssertTrue( result, @"method's result should be true." );
    XCTAssertNotNil( [configureData configureData], @"configure Data container should not be nil" );
    NSLog( @"container : %@", [configureData configureData] );
    
    NSString                      * fullPath;
    NSBundle                      * bundle;
    NSString                      * bundleResourcePath;
    
    bundle                          = [NSBundle bundleForClass: [self class]];
    XCTAssertNotNil( bundle, @"the bundle should not b nil" );
    bundleResourcePath              = [bundle resourcePath];
    XCTAssertNotNil( bundleResourcePath, @"the bundle's path should not b nil" );
    
    
    fullPath                        = [bundleResourcePath stringByAppendingPathComponent: @"Tester/Resources.zip"];
    result                          = [configureData updateConfigureData: @"StickerLibraryTabUpdate" type: TDConfigureDataSourceFileTypePList encoding: NSUTF8StringEncoding
                                                           withConfigure: @"Tab" and: @"Name"
                                                                    from: fullPath inZippedPath: @"Resources" with: nil];
    XCTAssertTrue( result, @"method's result should be true." );
    
}

//  --------------------------------
//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


@end
















