//
//  RNSegmentIOAnalytics
//
//  Created by Tal Kain <tal@kain.net>.
//  Copyright (c) 2015 Fire Place Inc. All rights reserved.
//

#import "RNSegmentIOAnalytics.h"
#import "RCTConvert.h"
#import "SEGAnalytics.h"
#import <Foundation/Foundation.h>

@implementation RNSegmentIOAnalytics

static OnSetupConfigFinishedBlock gOnSetupConfigFinishedBlock = nil;
static OnSetupFinishedBlock gOnSetupFinishedBlock = nil;

+ (OnSetupConfigFinishedBlock)onSetupConfigFinishedBlock {
    return gOnSetupConfigFinishedBlock;
}

+ (void)setOnSetupConfigFinishedBlock:(OnSetupConfigFinishedBlock)block {
    gOnSetupConfigFinishedBlock = [block copy];
}

+ (OnSetupFinishedBlock)onSetupFinishedBlock {
    return gOnSetupFinishedBlock;
}

+ (void)setOnSetupFinishedBlock:(OnSetupFinishedBlock)block {
    gOnSetupFinishedBlock = [block copy];
}


RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(setup:(NSString*)configKey options:(NSDictionary *)options)
{
    SEGAnalyticsConfiguration *configuration = [SEGAnalyticsConfiguration configurationWithWriteKey:configKey];
    id flushAtObject = [options objectForKey:@"flushAt"];
    if (flushAtObject) {
        configuration.flushAt = [RCTConvert NSUInteger:flushAtObject];
    }
    id trackApplicationLifecycleEventsObject = [options objectForKey:@"trackApplicationLifecycleEvents"];
    if (trackApplicationLifecycleEventsObject) {
        configuration.trackApplicationLifecycleEvents = [RCTConvert BOOL:trackApplicationLifecycleEventsObject];
    }
    id recordScreenViewsObject = [options objectForKey:@"recordScreenViews"];
    if (recordScreenViewsObject) {
        configuration.recordScreenViews = [RCTConvert BOOL:recordScreenViewsObject];
    }
    id shouldUseLocationServicesObject = [options objectForKey:@"shouldUseLocationServices"];
    if (shouldUseLocationServicesObject) {
        configuration.shouldUseLocationServices = [RCTConvert BOOL:shouldUseLocationServicesObject];
    }

    if (gOnSetupConfigFinishedBlock) {
        gOnSetupConfigFinishedBlock(configuration);
    }

    [SEGAnalytics setupWithConfiguration:configuration];
    id debugObject = [options objectForKey:@"debug"];
    if (debugObject) {
        [SEGAnalytics debug:[RCTConvert BOOL:debugObject]];
    }

    if (gOnSetupFinishedBlock) {
        gOnSetupFinishedBlock();
    }
}

/*
 https://segment.com/docs/libraries/ios/#identify
 */
RCT_EXPORT_METHOD(identifyUser:(NSString*)userId traits:(NSDictionary *)traits) {
    [[SEGAnalytics sharedAnalytics] identify:userId traits:[self convertToStringDictionary:traits]];
}

/*
 https://segment.com/docs/libraries/ios/#alias
 */
RCT_EXPORT_METHOD(alias:(NSString *)newId) {
    [[SEGAnalytics sharedAnalytics] alias:newId];
}

/*
 https://segment.com/docs/libraries/ios/#track
 */
RCT_EXPORT_METHOD(track:(NSString*)trackText properties:(NSDictionary *)properties) {
    [[SEGAnalytics sharedAnalytics] track:trackText
                               properties:[self convertToStringDictionary:properties]];
}
/*
 https://segment.com/docs/libraries/ios/#screen
 */
RCT_EXPORT_METHOD(screen:(NSString*)screenName properties:(NSDictionary *)properties) {
    [[SEGAnalytics sharedAnalytics] screen:screenName properties:[self convertToStringDictionary:properties]];
}

/*
 https://segment.com/docs/libraries/ios/#flushing
 */
RCT_EXPORT_METHOD(flush) {
    [[SEGAnalytics sharedAnalytics] flush];
}

/*
 https://segment.com/docs/libraries/ios/#reset
 */
RCT_EXPORT_METHOD(reset) {
    [[SEGAnalytics sharedAnalytics] reset];
}

/*
 https://segment.com/docs/libraries/ios/#logging
 */
RCT_EXPORT_METHOD(debug: (BOOL)isEnabled) {
    [SEGAnalytics debug:isEnabled];
}

/*
 https://segment.com/docs/libraries/ios/#opt-out
 */
RCT_EXPORT_METHOD(disable) {
    [[SEGAnalytics sharedAnalytics] disable];
}

/*
 https://segment.com/docs/libraries/ios/#opt-out
 */
RCT_EXPORT_METHOD(enable) {
    [[SEGAnalytics sharedAnalytics] enable];
}

-(NSMutableDictionary*) convertToStringDictionary: (NSDictionary *)properties {
    /*
     According to React Native's documentation:
     
     For maps, it is the developer's responsibility to check the value types individually by manually calling RCTConvert helper methods.
     */
    NSMutableDictionary *stringDictionary = [[NSMutableDictionary alloc] init];
    for (NSString* key in [properties allKeys]) {
        id value = [RCTConvert NSString:[properties objectForKey:key]];
        [stringDictionary setObject:value forKey:[RCTConvert NSString:key]];
    }
    return stringDictionary;
}

@end
