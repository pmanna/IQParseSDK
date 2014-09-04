//
//  IQ_PFConstants.h
//  IQParseSDK
//
//  Created by Mohd Iftekhar Qurashi on 08/09/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import <objc/objc.h>

@class NSDictionary, NSError, NSArray, NSString;
@class IQ_PFUser, IQ_PFObject;

//typedef enum {
//    kIQ_PFCachePolicyIgnoreCache = 0,
//    kIQ_PFCachePolicyCacheOnly,
//    kIQ_PFCachePolicyNetworkOnly,
//    kIQ_PFCachePolicyCacheElseNetwork,
//    kIQ_PFCachePolicyNetworkElseCache,
//    kIQ_PFCachePolicyCacheThenNetwork
//} IQ_PFCachePolicy;


typedef void (^IQ_PFBooleanResultBlock)     (BOOL succeeded,        NSError *error);
typedef void (^IQ_PFIntegerResultBlock)     (int number,            NSError *error);
typedef void (^IQ_PFArrayResultBlock)       (NSArray *objects,      NSError *error);
typedef void (^IQ_PFObjectResultBlock)      (IQ_PFObject *object,   NSError *error);
typedef void (^IQ_PFSetResultBlock)         (NSSet *channels,       NSError *error);
typedef void (^IQ_PFUserResultBlock)        (IQ_PFUser *user,       NSError *error);
typedef void (^IQ_PFDataResultBlock)        (NSData *data,          NSError *error);
typedef void (^IQ_PFDataStreamResultBlock)  (NSInputStream *stream, NSError *error);
typedef void (^IQ_PFStringResultBlock)      (NSString *string,      NSError *error);
typedef void (^IQ_PFIdResultBlock)          (id object,             NSError *error);
typedef void (^IQ_PFProgressBlock)          (int percentDone);

extern NSString *const IQ_PARSE_APP_ID;
extern NSString *const IQ_PARSE_REST_KEY;
