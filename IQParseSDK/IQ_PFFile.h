//
//  IQ_PFFile.h
//  IQParseSDK
//
//  Created by Iftekhar on 07/10/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import <Foundation/NSObject.h>
#import "IQ_PFConstants.h"

@class NSData;

@interface IQ_PFFile : NSObject

//+ (instancetype)fileWithData:(NSData *)data;
//+ (instancetype)fileWithName:(NSString *)name data:(NSData *)data;
//+ (instancetype)fileWithName:(NSString *)name contentsAtPath:(NSString *)path;
//+ (instancetype)fileWithName:(NSString *)name data:(NSData *)data contentType:(NSString *)contentType;
//+ (instancetype)fileWithData:(NSData *)data contentType:(NSString *)contentType;

//@property (nonatomic, strong, readonly) NSString *name;
//@property (nonatomic, strong, readonly) NSString *url;

//@property (nonatomic, assign, readonly) BOOL isDirty;

//- (BOOL)save;
//- (BOOL)save:(NSError **)error;
//- (void)saveInBackground;
//- (void)saveInBackgroundWithBlock:(IQ_PFBooleanResultBlock)block;
//- (void)saveInBackgroundWithBlock:(IQ_PFBooleanResultBlock)block progressBlock:(IQ_PFProgressBlock)progressBlock;
//- (void)saveInBackgroundWithTarget:(id)target selector:(SEL)selector;

//@property (assign, readonly) BOOL isDataAvailable;

//- (NSData *)getData;
//- (NSInputStream *)getDataStream;
//- (NSData *)getData:(NSError **)error;
//- (NSInputStream *)getDataStream:(NSError **)error;
//- (void)getDataInBackgroundWithBlock:(IQ_PFDataResultBlock)block;
//- (void)getDataStreamInBackgroundWithBlock:(IQ_PFDataStreamResultBlock)block;
//- (void)getDataInBackgroundWithBlock:(IQ_PFDataResultBlock)resultBlock progressBlock:(IQ_PFProgressBlock)progressBlock;
//- (void)getDataStreamInBackgroundWithBlock:(IQ_PFDataStreamResultBlock)resultBlock progressBlock:(IQ_PFProgressBlock)progressBlock;
//- (void)getDataInBackgroundWithTarget:(id)target selector:(SEL)selector;

//- (void)cancel;

@end
