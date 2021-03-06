//
//  IQ_PFInstallation.h
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

#import "IQ_PFObject.h"
#import "IQ_PFQuery.h"

@interface IQ_PFInstallation : IQ_PFObject

+ (NSString *)parseClassName;

+ (IQ_PFQuery *)query;

+ (instancetype)currentInstallation;

- (void)setDeviceTokenFromData:(NSData *)deviceTokenData;

@property (nonatomic, strong, readonly) NSString    *deviceType;
@property (nonatomic, strong, readonly) NSString    *installationId;
@property (nonatomic, strong) NSString              *deviceToken;
@property (nonatomic, assign) NSInteger             badge;
@property (nonatomic, strong, readonly) NSString    *timeZone;
@property (nonatomic, strong) NSArray               *channels;


@end
