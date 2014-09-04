//
//  IQ_Parse.m
//  IQParseSDK
//
//  Created by Iftekhar on 03/09/14.
//  Copyright (c) 2014 Iftekhar. All rights reserved.
//

#import "IQ_Parse.h"

@implementation IQ_Parse

static NSString *PARSE_APPLICATION_ID=   @"kk7wtCOCuafGq4EuSZXKy66RuUKBHjUYrJlDp0d7";
static NSString *PARSE_REST_API_KEY  =   @"jBPJ9swSZq97gmXqDNG1Gm57XBG0cSdC3smdIHdJ";

+ (void)setApplicationId:(NSString *)applicationId restAPIKey:(NSString *)restAPIKey;
{
    PARSE_APPLICATION_ID = applicationId;
    PARSE_REST_API_KEY = restAPIKey;
}

+ (NSString *)getApplicationId
{
    return PARSE_APPLICATION_ID;
}

+ (NSString *)getRestAPIKey;
{
    return PARSE_REST_API_KEY;
}

@end
