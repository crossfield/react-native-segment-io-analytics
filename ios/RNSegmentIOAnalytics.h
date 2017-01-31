//
//  RNSegmentIOAnalytics
//
//  Created by Tal Kain <tal@kain.net>.
//  Copyright (c) 2015 Fire Place Inc. All rights reserved.
//

#import "RCTBridgeModule.h"

@class SEGAnalyticsConfiguration;

typedef void (^OnSetupConfigFinishedBlock)(SEGAnalyticsConfiguration *config);
typedef void (^OnSetupFinishedBlock)();

/*
 * React native wrapper of the Segment.com's Analytics iOS SDK
 */
@interface RNSegmentIOAnalytics : NSObject <RCTBridgeModule>

+ (OnSetupConfigFinishedBlock)onSetupConfigFinishedBlock;
+ (void)setOnSetupConfigFinishedBlock:(OnSetupConfigFinishedBlock)block;

+ (OnSetupFinishedBlock)onSetupFinishedBlock;
+ (void)setOnSetupFinishedBlock:(OnSetupFinishedBlock)block;

@end
