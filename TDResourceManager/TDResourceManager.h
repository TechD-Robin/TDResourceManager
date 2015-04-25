//
//  TDResourceManager.h
//  TDResourceManager
//
//  Created by Robin Hsu on 2015/4/25.
//  Copyright (c) 2015年 TechD. All rights reserved.
//

#import <Foundation/Foundation.h>


//  ------------------------------------------------------------------------------------------------
#pragma mark declare enumeration.
//  ------------------------------------------------------------------------------------------------
typedef NS_ENUM( NSInteger, TDResourceManageDataType ) {
    TDResourceManageDataTypeDefault             = 0,    // in resource path
    TDResourceManageDataTypeInAssetsBundle,
    TDResourceManageDataTypeInZipped,
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


@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------



