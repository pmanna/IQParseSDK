//
//  IQ_Parse.h
//  IQParseSDK
//
//  Created by Iftekhar on 03/09/14.
//  Copyright (c) 2014 Iftekhar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IQ_Parse : NSObject

+ (void)setApplicationId:(NSString *)applicationId restAPIKey:(NSString *)restAPIKey;
+ (NSString *)getApplicationId;
+ (NSString *)getRestAPIKey;
//
//+ (void)offlineMessagesEnabled:(BOOL)enabled;
//+ (void)errorMessagesEnabled:(BOOL)enabled;

@end
