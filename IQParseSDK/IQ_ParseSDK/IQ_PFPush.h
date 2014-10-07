//
//  IQ_PFPush.h
//  IQParseSDK Demo
//
//  Created by Paolo Manna on 06/10/2014.
//  Copyright (c) 2014 Paolo Manna. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

@interface IQ_PFPush : NSObject

+ (instancetype)push;

//- (void)setChannel:(NSString *)channel;
//- (void)setChannels:(NSArray *)channels;
//- (void)setQuery:(IQ_PFQuery *)query;
//- (void)setMessage:(NSString *)message;
//- (void)setData:(NSDictionary *)data;
//
//- (void)expireAtDate:(NSDate *)date;
//- (void)expireAfterTimeInterval:(NSTimeInterval)timeInterval;
//- (void)clearExpiration;
//
//+ (BOOL)sendPushMessageToChannel:(NSString *)channel
//                     withMessage:(NSString *)message
//                           error:(NSError **)error;
//+ (void)sendPushMessageToChannelInBackground:(NSString *)channel
//                                 withMessage:(NSString *)message;
//+ (void)sendPushMessageToChannelInBackground:(NSString *)channel
//                                 withMessage:(NSString *)message
//                                       block:(IQ_PFBooleanResultBlock)block;
//+ (void)sendPushMessageToChannelInBackground:(NSString *)channel
//                                 withMessage:(NSString *)message
//                                      target:(id)target
//                                    selector:(SEL)selector;
//+ (BOOL)sendPushMessageToQuery:(IQ_PFQuery *)query
//                   withMessage:(NSString *)message
//                         error:(NSError **)error;
//+ (void)sendPushMessageToQueryInBackground:(IQ_PFQuery *)query
//                               withMessage:(NSString *)message;
//+ (void)sendPushMessageToQueryInBackground:(IQ_PFQuery *)query
//                               withMessage:(NSString *)message
//                                     block:(IQ_PFBooleanResultBlock)block;
//- (BOOL)sendPush:(NSError **)error;
//- (void)sendPushInBackground;
//- (void)sendPushInBackgroundWithBlock:(IQ_PFBooleanResultBlock)block;
//- (void)sendPushInBackgroundWithTarget:(id)target selector:(SEL)selector;
//+ (BOOL)sendPushDataToChannel:(NSString *)channel
//                     withData:(NSDictionary *)data
//                        error:(NSError **)error;
//+ (void)sendPushDataToChannelInBackground:(NSString *)channel
//                                 withData:(NSDictionary *)data;
//+ (void)sendPushDataToChannelInBackground:(NSString *)channel
//                                 withData:(NSDictionary *)data
//                                    block:(IQ_PFBooleanResultBlock)block;
//+ (void)sendPushDataToChannelInBackground:(NSString *)channel
//                                 withData:(NSDictionary *)data
//                                   target:(id)target
//                                 selector:(SEL)selector;
//+ (BOOL)sendPushDataToQuery:(IQ_PFQuery *)query
//                   withData:(NSDictionary *)data
//                      error:(NSError **)error;
//+ (void)sendPushDataToQueryInBackground:(IQ_PFQuery *)query
//                               withData:(NSDictionary *)data;
//+ (void)sendPushDataToQueryInBackground:(IQ_PFQuery *)query
//                               withData:(NSDictionary *)data
//                                  block:(IQ_PFBooleanResultBlock)block;

+ (void)handlePush:(NSDictionary *)userInfo;
+ (void)storeDeviceToken:(id)deviceToken;

//+ (NSSet *)getSubscribedChannels:(NSError **)error;
//+ (void)getSubscribedChannelsInBackgroundWithBlock:(IQ_PFSetResultBlock)block;
//+ (void)getSubscribedChannelsInBackgroundWithTarget:(id)target
//                                           selector:(SEL)selector;
//+ (BOOL)subscribeToChannel:(NSString *)channel error:(NSError **)error;
//+ (void)subscribeToChannelInBackground:(NSString *)channel;
//+ (void)subscribeToChannelInBackground:(NSString *)channel
//                                 block:(IQ_PFBooleanResultBlock)block;
//+ (void)subscribeToChannelInBackground:(NSString *)channel
//                                target:(id)target
//                              selector:(SEL)selector;
//+ (BOOL)unsubscribeFromChannel:(NSString *)channel error:(NSError **)error;
//+ (void)unsubscribeFromChannelInBackground:(NSString *)channel;
//+ (void)unsubscribeFromChannelInBackground:(NSString *)channel
//                                     block:(IQ_PFBooleanResultBlock)block;
//+ (void)unsubscribeFromChannelInBackground:(NSString *)channel
//                                    target:(id)target
//                                  selector:(SEL)selector;


@end
