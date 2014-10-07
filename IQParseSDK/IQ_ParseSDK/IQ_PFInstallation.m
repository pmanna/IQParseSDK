//
//  IQ_PFInstallation.m
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

#import "IQ_PFInstallation.h"
#import "IQPFHTTPService.h"
#import "NSData+Hex.h"

@interface IQ_PFObject (Subclassing)

@property (strong, nonatomic) NSMutableDictionary   *displayAttributes;
@property (strong, nonatomic) NSMutableDictionary   *needUpdateAttributes;

@property (strong, nonatomic) NSMutableSet          *connectionSet;

- (void)serializeAttributes: (NSDictionary*)result;
- (NSDictionary*)deserializedAttributes;

@end

@interface IQ_PFInstallation ()

@property (assign, atomic) BOOL     isRefreshing;

- (void)fillInstallationDetails;

@end

@implementation IQ_PFInstallation

+ (NSString *)parseClassName
{
    return @"_Installation";
}


+ (IQ_PFQuery *)query
{
    // Queries on Installation aren't allowed without Master Key
    return nil;
}

+ (instancetype)currentInstallation
{
    static IQ_PFInstallation    *_currentInstallation = nil;
    static dispatch_once_t      onceToken;
    
    dispatch_once(&onceToken, ^{
        _currentInstallation = [[self alloc] init];
    });
    
    return _currentInstallation;
}

- (instancetype)init
{
    if ((self = [super init]) != nil) {
        self.objectId   = [[NSUserDefaults standardUserDefaults] objectForKey: @"PFInstallationId"];
        
        self.channels   = [NSMutableArray array];
        
        if (self.objectId) {
            self.isRefreshing   = YES;
            [self refreshInBackgroundWithBlock:^(IQ_PFObject *object, NSError *error) {
                self.deviceToken    = [self objectForKey: @"deviceToken"];
                self.badge          = [[self objectForKey: @"badge"] integerValue];
                if ([self objectForKey: @"channels"])
                    self.channels   = [NSMutableArray arrayWithArray: [self objectForKey: @"channels"]];
                self.isRefreshing   = NO;
            }];
        }
    }
    
    return self;
}

- (void)setDeviceTokenFromData:(NSData *)deviceTokenData
{
    self.deviceToken    = [deviceTokenData hexadecimalString];
}

- (NSString *)deviceType
{
    return @"ios";
}

- (NSString *)installationId
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString *)timeZone
{
    return [[[NSCalendar currentCalendar] timeZone] name];
}

- (void)fillInstallationDetails
{
    NSBundle    *mb = [NSBundle mainBundle];
    
    if (self.deviceToken)
        [self setObject: self.deviceToken forKey: @"deviceToken"];
    
    [self setObject: @(self.badge) forKey: @"badge"];
    [self setObject: self.deviceType forKey: @"deviceType"];
    [self setObject: self.installationId forKey: @"installationId"];
    [self setObject: self.timeZone forKey: @"timeZone"];
    [self setObject: self.channels forKey: @"channels"];
    
    [self setObject: [mb objectForInfoDictionaryKey: @"CFBundleDisplayName"] forKey: @"appName"];
    [self setObject: [mb objectForInfoDictionaryKey: @"CFBundleVersion"] forKey: @"appVersion"];
    [self setObject: [mb bundleIdentifier] forKey: @"appIdentifier"];
}

#pragma mark - Subclassing IQ_PFObject to handle Installation objects

- (void)refresh:(NSError **)error
{
    NSDictionary *result = [[IQPFHTTPService service] installationWithObjectId: self.objectId
                                                                         error: error];
    
    if (result) {
        [self serializeAttributes:result];
    }
}

- (void)refreshInBackgroundWithBlock:(IQ_PFObjectResultBlock)block
{
    __block IQURLConnection *connection = [[IQPFHTTPService service] installationWithObjectId: self.objectId
                                                                            completionHandler:^(NSDictionary *result, NSError *error) {
        
        if (connection) [self.connectionSet removeObject:connection];
        
        if (result) {
            [self serializeAttributes:result];
        }
        
        if (block) {
            block((result!= nil)?self:nil,error);
        }
        
        if (connection) [self.connectionSet addObject:connection];
    }];
}

- (BOOL)save:(NSError **)error
{
    // Still reading, fake a successful saving, retry later
    // Not ideal, though, many cases this would cause issues
    if (self.isRefreshing) {
        [self performSelector: @selector(save:) withObject: nil afterDelay: 0.5];
        if (error)
            *error  = nil;
        
        return YES;
    }
    
    NSDictionary *result;
    
    [self fillInstallationDetails];
    
    if (self.objectId) {
        result = [[IQPFHTTPService service] updateInstallationWithObjectId: self.objectId
                                                                attributes: [self deserializedAttributes]
                                                                     error: error];
    } else {
        result = [[IQPFHTTPService service] createInstallationWithAttributes: [self deserializedAttributes]
                                                                       error: error];
    }
    
    
    if (result) {
        NSUserDefaults  *ud = [NSUserDefaults standardUserDefaults];
        
        [self serializeAttributes:result];
        
        [ud setObject: self.objectId forKey: @"PFInstallationId"];
        [ud synchronize];
        
        return YES;
    } else {
        return NO;
    }
}

- (void)saveInBackgroundWithBlock:(IQ_PFBooleanResultBlock)block
{
    if (self.isRefreshing) {
        // Still reading, retry later
        // This is safer than above, block will be called properly
        [self performSelector: @selector(saveInBackgroundWithBlock:)
                   withObject: block
                   afterDelay: 0.5];
        return;
    }
    
    [self fillInstallationDetails];
    
    if (self.objectId) {
        __block IQURLConnection *connection = [[IQPFHTTPService service] updateInstallationWithObjectId: self.objectId
                                                                                             attributes: [self deserializedAttributes]
                                                                                      completionHandler: ^(NSDictionary *result, NSError *error) {
            
            if (connection) [self.connectionSet removeObject:connection];
            
            if (result) {
                [self serializeAttributes:result];
            }
            
            if (block) {
                block((result!= nil),error);
            }
        }];
        
        if (connection) [self.connectionSet addObject:connection];
    } else {
        __block IQURLConnection *connection = [[IQPFHTTPService service] createInstallationWithAttributes: [self deserializedAttributes]
                                                                                        completionHandler: ^(NSDictionary *result, NSError *error) {
            
            if (connection) [self.connectionSet removeObject:connection];
            
            if (result) {
                NSUserDefaults  *ud = [NSUserDefaults standardUserDefaults];
                
                [self serializeAttributes:result];
                
                [ud setObject: self.objectId forKey: @"PFInstallationId"];
                [ud synchronize];
            }
            
            if (block) {
                block((result!= nil),error);
            }
        }];
        
        if (connection) [self.connectionSet addObject:connection];
    }
}

@end
