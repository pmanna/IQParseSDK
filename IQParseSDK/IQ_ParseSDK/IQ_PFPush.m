//
//  IQ_PFPush.m
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

#import "IQ_PFPush.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NSData+Hex.h"

static NSMutableDictionary *notificationSounds;

@implementation IQ_PFPush

+ (instancetype)push
{
    return [[IQ_PFPush alloc] init];
}

+ (void)handlePush:(NSDictionary *)userInfo
{
    NSDictionary    *payloadDict    = userInfo[@"aps"];
    
    if (payloadDict[@"badge"]) {
        [UIApplication sharedApplication].applicationIconBadgeNumber    = [payloadDict[@"badge"] integerValue];
    }
    
    if ([payloadDict[@"sound"] length]) {
        NSString        *soundName  = payloadDict[@"sound"];
        NSString        *soundPath  = [[NSBundle mainBundle] pathForResource: [soundName stringByDeletingPathExtension]
                                                                      ofType: [soundName pathExtension]];
        SystemSoundID   soundId     = 0;
        
        if (!notificationSounds)
            notificationSounds  = [NSMutableDictionary dictionary];
        
        if (!notificationSounds[soundPath]) {
            CFURLRef    soundURL    = (CFURLRef)CFBridgingRetain([NSURL URLWithString: soundPath]);
            
            if (AudioServicesCreateSystemSoundID(soundURL, &soundId) == noErr) {
                notificationSounds[soundPath] = @(soundId);
            }
            
            CFRelease(soundURL);
        } else {
            soundId = (SystemSoundID)[notificationSounds[soundPath] integerValue];
        }
        
        AudioServicesPlayAlertSound(soundId);
    }
    
    if (payloadDict[@"alert"]) {
        [[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Push Notification", nil)
                                    message: NSLocalizedString(payloadDict[@"alert"], nil)
                                   delegate: nil
                          cancelButtonTitle: NSLocalizedString(@"OK", nil)
                          otherButtonTitles: nil] show];
    }
}

+ (void)storeDeviceToken: (id)deviceToken
{
    NSString        *aToken = nil;
    NSUserDefaults  *ud     = [NSUserDefaults standardUserDefaults];
    
    if ([deviceToken isKindOfClass: [NSData class]])
        aToken  = [(NSData *)deviceToken hexadecimalString];
    else if ([deviceToken isKindOfClass: [NSString class]])
        aToken  = deviceToken;
    
    if (aToken) {
        [ud setObject: aToken forKey: @"PFPushDeviceToken"];
        [ud synchronize];
    }
}

@end
