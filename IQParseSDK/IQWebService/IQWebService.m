//
//  IQWebService.m
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


#import "IQWebService.h"
#import "IQURLConnection.h"

@implementation IQWebService
{
    NSMutableDictionary *defaultHeaders;
}

@synthesize logEnabled = _logEnabled;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        defaultHeaders = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+(instancetype)service
{
    static IQWebService *sharedService;
    if (sharedService == nil)
    {
        sharedService = [[self alloc] init];
    }

    return sharedService;
}

-(BOOL)isLogEnabled
{
	return _logEnabled;
}

-(NSString*)headerForField:(NSString*)headerField
{
    return [defaultHeaders objectForKey:headerField];
}

-(void)addDefaultHeaderValue:(NSString*)header forHeaderField:(NSString*)headerField
{
    if (header)
    {
        [defaultHeaders setObject:header forKey:headerField];
    }
    else
    {
        [self removeDefaultHeaderForField:headerField];
    }
}

-(void)removeDefaultHeaderForField:(NSString*)headerField
{
    [defaultHeaders removeObjectForKey:headerField];
}

//Simple request
-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    return [self requestWithPath:path httpMethod:method parameter:parameter responseBlock:nil uploadProgressBlock:nil downloadProgressBlock:nil completionHandler:completionHandler];
}

//Download Upload Progress request
-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;
{
     return [self requestWithPath:path httpMethod:method parameter:parameter responseBlock:nil uploadProgressBlock:nil downloadProgressBlock:downloadProgress completionHandler:completionHandler];
}

-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter uploadProgressBlock:(IQProgressBlock)uploadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;
{
     return [self requestWithPath:path httpMethod:method parameter:parameter responseBlock:nil uploadProgressBlock:uploadProgress downloadProgressBlock:nil completionHandler:completionHandler];
}

-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter uploadProgressBlock:(IQProgressBlock)uploadProgress downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;
{
     return [self requestWithPath:path httpMethod:method parameter:parameter responseBlock:nil uploadProgressBlock:uploadProgress downloadProgressBlock:downloadProgress completionHandler:completionHandler];
}

//Simple request + HTTPResponse
-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter responseBlock:(IQResponseBlock)response completionHandler:(IQDictionaryCompletionBlock)completionHandler;
{
     return [self requestWithPath:path httpMethod:method parameter:parameter responseBlock:response uploadProgressBlock:nil downloadProgressBlock:nil completionHandler:completionHandler];
}

//Download Upload Progress request + HTTPResponse
-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter responseBlock:(IQResponseBlock)response downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;
{
     return [self requestWithPath:path httpMethod:method parameter:parameter responseBlock:response uploadProgressBlock:downloadProgress downloadProgressBlock:nil completionHandler:completionHandler];
}

-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter responseBlock:(IQResponseBlock)response uploadProgressBlock:(IQProgressBlock)uploadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;
{
     return [self requestWithPath:path httpMethod:method parameter:parameter responseBlock:response uploadProgressBlock:uploadProgress downloadProgressBlock:nil completionHandler:completionHandler];
}

-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter responseBlock:(IQResponseBlock)response uploadProgressBlock:(IQProgressBlock)uploadProgress downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    return [self requestWithPath:path httpMethod:method contentType:self.defaultContentType parameter:parameter responseBlock:response uploadProgressBlock:uploadProgress downloadProgressBlock:downloadProgress completionHandler:completionHandler];
}

-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method contentType:(NSString*)contentType httpBody:(NSData*)httpBody completionHandler:(IQDictionaryCompletionBlock)completionHandler;
{
    return [self requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",self.serverURL,path] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]] httpMethod:method contentType:contentType httpBody:httpBody responseBlock:nil uploadProgressBlock:nil downloadProgressBlock:nil completionHandler:completionHandler];
}

-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method contentType:(NSString*)contentType parameter:(NSDictionary*)parameter responseBlock:(IQResponseBlock)response uploadProgressBlock:(IQProgressBlock)uploadProgress downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    NSURL *url = nil;
    NSData *httpBody = nil;
    
    if ([method isEqualToString:kIQHTTPMethodGET])
    {
        NSMutableString *parameterString = [[NSMutableString alloc] init];
        if ([path hasSuffix:@"?"] == NO && [parameter count])
            [parameterString appendString:@"?"];
        
        [parameterString appendString:[[self class] httpParameterString:parameter]];
        
        url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@%@",self.serverURL,path,parameterString] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    }
    else if ([method isEqualToString:kIQHTTPMethodPOST])
    {
        url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",self.serverURL,path] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        
        NSData *originalData;
        
        if (self.parameterType == IQRequestParameterTypeApplicationJSON)
        {
            if (parameter)  originalData = [NSJSONSerialization dataWithJSONObject:parameter options:0 error:nil];
        }
        else if (self.parameterType == IQRequestParameterTypeApplicationXWwwFormUrlEncoded)
        {
            if (parameter)
            {
                NSString *parameterString = [[self class] httpParameterString:parameter];
                originalData = [parameterString dataUsingEncoding:NSUTF8StringEncoding];
            }
        }
        
        if ([originalData length])
        {
            NSMutableData *editedData = [[NSMutableData alloc] init];
            
            if (self.startBodyData) [editedData appendData:self.startBodyData];
            if (originalData)       [editedData appendData:originalData];
            if (self.endBodyData)   [editedData appendData:self.endBodyData];
            
            httpBody = editedData;
        }
    }
    
    return [self requestWithURL:url httpMethod:method contentType:contentType httpBody:httpBody responseBlock:response uploadProgressBlock:uploadProgress downloadProgressBlock:downloadProgress completionHandler:completionHandler];
}

-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method contentType:(NSString*)contentType httpBody:(NSData*)httpBody responseBlock:(IQResponseBlock)response uploadProgressBlock:(IQProgressBlock)uploadProgress downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",self.serverURL,path] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    return [self requestWithURL:url httpMethod:method contentType:contentType httpBody:httpBody responseBlock:response uploadProgressBlock:uploadProgress downloadProgressBlock:downloadProgress completionHandler:completionHandler];
}

-(IQURLConnection*)requestWithURL:(NSURL*)url httpMethod:(NSString*)method contentType:(NSString*)contentType httpBody:(NSData*)httpBody responseBlock:(IQResponseBlock)response uploadProgressBlock:(IQProgressBlock)uploadProgress downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    return [self requestWithURL:url httpMethod:method contentType:contentType httpBody:httpBody responseBlock:response uploadProgressBlock:uploadProgress downloadProgressBlock:downloadProgress dataCompletionHandler:^(NSData *result, NSError *error) {

        if (completionHandler != NULL)
        {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(response, error);
            });
        }
    }];
}

-(IQURLConnection*)requestWithURL:(NSURL*)url httpMethod:(NSString*)method contentType:(NSString*)contentType httpBody:(NSData*)httpBody responseBlock:(IQResponseBlock)response uploadProgressBlock:(IQProgressBlock)uploadProgress downloadProgressBlock:(IQProgressBlock)downloadProgress dataCompletionHandler:(IQDataCompletionBlock)completionHandler
{
    NSMutableURLRequest *request = [IQWebService requestWithURL:url httpMethod:method contentType:contentType body:httpBody];
    
    //Adding headers
    {
        [request setAllHTTPHeaderFields:defaultHeaders];
    }
    
    if (_logEnabled)
	{
		NSLog(@"RequestURL:- %@",request.URL);
		NSLog(@"HTTP Method:- %@",request.HTTPMethod);
		NSLog(@"HTTPHeaderFields:- %@",request.allHTTPHeaderFields);
		NSLog(@"Body:- %@\n\n",[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
	}
    
    IQURLConnection *connection = [IQURLConnection sendAsynchronousRequest:request responseBlock:response uploadProgressBlock:uploadProgress downloadProgressBlock:downloadProgress completionHandler:^(NSData *result, NSError *error) {
        if (_logEnabled)
        {
            NSLog(@"URL:- %@",request.URL);
            NSLog(@"HTTP Method:- %@",request.HTTPMethod);
            NSLog(@"Response HeaderFields:- %@", connection.response.allHeaderFields);
            
            if (error)
            {
                NSLog(@"error:- %@\n\n",error);
            }
            
            if (result)
            {
                NSLog(@"Response:- %@\n\n",[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);
            }
        }
        
        if (completionHandler != NULL)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(result, error);
            });
        }
    }];
    
    return connection;
}

+(NSString*)httpParameterString:(NSDictionary*)dictionary
{
    NSMutableString *parameterString = [[NSMutableString alloc] init];
    
    for (NSString *aKey in [dictionary allKeys])
    {
        [parameterString appendFormat:@"%@=%@&",aKey,[dictionary objectForKey:aKey]];
    }
    
    if ([parameterString length])
    {
        [parameterString replaceCharactersInRange:NSMakeRange(parameterString.length-1, 1) withString:@""];
    }
    
    return parameterString;
}

+(NSMutableURLRequest*)requestWithURL:(NSURL*)url httpMethod:(NSString*)httpMethod contentType:(NSString*)contentType body:(NSData*)body
{
    if (url != nil)
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:300];
        
        if ([httpMethod length])    [request setHTTPMethod:httpMethod];
        if ([contentType length])   [request addValue:contentType forHTTPHeaderField:kIQContentType];
        if ([body length])
        {
            [request setHTTPBody:body];
            [request addValue:[NSString stringWithFormat:@"%d",[body length]] forHTTPHeaderField:kIQContentLength];
        }
        return request;
    }
    else
    {
        return nil;
    }
}


@end


