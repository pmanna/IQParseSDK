//
//  IQ_PFUser.h
//  IQParseSDK
//
//  Created by Iftekhar on 03/09/14.
//  Copyright (c) 2014 Iftekhar. All rights reserved.
//

#import "IQ_PFObject.h"

@class IQ_PFQuery;

@interface IQ_PFUser : IQ_PFObject

//+ (NSString *)parseClassName;
//+ (instancetype)currentUser;

//@property (nonatomic, strong) NSString *sessionToken;
//@property (assign, readonly) BOOL isNew;

//- (BOOL)isAuthenticated;
//+ (IQ_PFUser *)user;
//+ (void)enableAutomaticUser;

//@property (nonatomic, strong) NSString *username;
//@property (nonatomic, strong) NSString *password;
//@property (nonatomic, strong) NSString *email;

//- (BOOL)signUp;
//- (BOOL)signUp:(NSError **)error;
//- (void)signUpInBackground;
//- (void)signUpInBackgroundWithBlock:(IQ_PFBooleanResultBlock)block;
//- (void)signUpInBackgroundWithTarget:(id)target selector:(SEL)selector;

//+ (instancetype)logInWithUsername:(NSString *)username password:(NSString *)password;
//+ (instancetype)logInWithUsername:(NSString *)username password:(NSString *)password error:(NSError **)error;
//+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password;
//+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password target:(id)target selector:(SEL)selector;
//+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password block:(IQ_PFUserResultBlock)block;
//+ (instancetype)become:(NSString *)sessionToken;
//+ (instancetype)become:(NSString *)sessionToken error:(NSError **)error;
//+ (void)becomeInBackground:(NSString *)sessionToken;
//+ (void)becomeInBackground:(NSString *)sessionToken target:(id)target selector:(SEL)selector;
//+ (void)becomeInBackground:(NSString *)sessionToken block:(IQ_PFUserResultBlock)block;

//+ (void)logOut;

//+ (BOOL)requestPasswordResetForEmail:(NSString *)email;
//+ (BOOL)requestPasswordResetForEmail:(NSString *)email error:(NSError **)error;
//+ (void)requestPasswordResetForEmailInBackground:(NSString *)email;
//+ (void)requestPasswordResetForEmailInBackground:(NSString *)email target:(id)target selector:(SEL)selector;
//+ (void)requestPasswordResetForEmailInBackground:(NSString *)email block:(IQ_PFBooleanResultBlock)block;

//+ (IQ_PFQuery *)query;

@end
