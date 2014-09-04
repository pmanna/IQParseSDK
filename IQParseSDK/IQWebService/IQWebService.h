//
//  IQWebService.h
// https://github.com/hackiftekhar/IQWebService
// Copyright (c) 2013-14 Iftekhar Qurashi.
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
#import "IQWebServiceConstants.h"

@class IQURLConnection;

@interface IQWebService : NSObject

@property(nonatomic, assign, getter = isLogEnabled) BOOL logEnabled;
@property(nonatomic, assign) IQRequestParameterType parameterType;
@property(nonatomic, retain) NSString *defaultContentType;
@property(nonatomic, retain) NSString *serverURL;
@property(nonatomic, retain) NSData *startBodyData;
@property(nonatomic, retain) NSData *endBodyData;

-(NSString*)headerForField:(NSString*)headerField;
-(void)addDefaultHeaderValue:(NSString*)header forHeaderField:(NSString*)headerField;
-(void)removeDefaultHeaderForField:(NSString*)headerField;

+(NSString*)httpParameterString:(NSDictionary*)dictionary;

//Shared Instance
+(instancetype)service;

//Simple request
-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//Download Upload Progress request
-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;
-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter uploadProgressBlock:(IQProgressBlock)uploadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;
-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter uploadProgressBlock:(IQProgressBlock)uploadProgress downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//Simple request + HTTPResponse
-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter responseBlock:(IQResponseBlock)response completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//Download Upload Progress request + HTTPResponse
-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter responseBlock:(IQResponseBlock)response downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;
-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter responseBlock:(IQResponseBlock)response uploadProgressBlock:(IQProgressBlock)uploadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;
-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter responseBlock:(IQResponseBlock)response uploadProgressBlock:(IQProgressBlock)uploadProgress downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;


//Request with content-Type
-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method contentType:(NSString*)contentType httpBody:(NSData*)httpBody completionHandler:(IQDictionaryCompletionBlock)completionHandler;

-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method contentType:(NSString*)contentType parameter:(NSDictionary*)parameter responseBlock:(IQResponseBlock)response uploadProgressBlock:(IQProgressBlock)uploadProgress downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;

-(IQURLConnection*)requestWithURL:(NSURL*)url httpMethod:(NSString*)method contentType:(NSString*)contentType httpBody:(NSData*)httpBody responseBlock:(IQResponseBlock)response uploadProgressBlock:(IQProgressBlock)uploadProgress downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;

@end
