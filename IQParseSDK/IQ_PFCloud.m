//
//  IQ_PFCloud.m
//  IQParseSDK
//
//  Created by Iftekhar on 03/09/14.
//  Copyright (c) 2014 Iftekhar. All rights reserved.
//

#import "IQ_PFCloud.h"
#import "IQ_PFWebService.h"

@implementation IQ_PFCloud

+ (void)callFunctionInBackground:(NSString *)function withParameters:(NSDictionary *)parameters block:(IQ_PFIdResultBlock)block
{
    [[IQ_PFWebService service] callFunction:function withParameters:parameters completionHandler:^(NSDictionary *result, NSError *error) {
        
        if (block)
        {
            block(result, error);
        }
    }];
}

+ (void)callFunctionInBackground:(NSString *)function withParameters:(NSDictionary *)parameters target:(id)target selector:(SEL)selector
{
    [self callFunctionInBackground:function withParameters:parameters block:^(id object, NSError *error) {

        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
        [invocation setArgument:&object atIndex:2];
        [invocation setArgument:&error atIndex:3];
        [invocation invoke];
    }];
}

@end
