//
//  IQ_PFCloud.h
//  IQParseSDK
//
//  Created by Iftekhar on 03/09/14.
//  Copyright (c) 2014 Iftekhar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IQ_PFConstants.h"

@interface IQ_PFCloud : NSObject

//+ (id)callFunction:(NSString *)function withParameters:(NSDictionary *)parameters;
//+ (id)callFunction:(NSString *)function withParameters:(NSDictionary *)parameters error:(NSError **)error;
+ (void)callFunctionInBackground:(NSString *)function withParameters:(NSDictionary *)parameters block:(IQ_PFIdResultBlock)block;
+ (void)callFunctionInBackground:(NSString *)function withParameters:(NSDictionary *)parameters target:(id)target selector:(SEL)selector;

@end
