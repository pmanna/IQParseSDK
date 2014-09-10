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
#import <MobileCoreServices/MobileCoreServices.h>

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

#pragma mark -
#pragma mark - Asynchronous Requests

-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    return [self requestWithPath:path httpMethod:method parameter:parameter dataCompletionHandler:^(NSData *result, NSError *error) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        
        if (completionHandler)
        {
            completionHandler(dict,error);
        }

    }];
}

-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter dataCompletionHandler:(IQDataCompletionBlock)completionHandler
{
    NSURL *url = nil;
    NSData *httpBody = nil;
    
    if ([method isEqualToString:kIQHTTPMethodGET])
    {
        NSMutableString *parameterString = [[NSMutableString alloc] init];
        if ([path hasSuffix:@"?"] == NO && [parameter count])
            [parameterString appendString:@"?"];
        
        [parameterString appendString:[[self class] httpURLEncodedString:parameter]];
        
        url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@%@",self.serverURL,path,parameterString] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    }
    else if ([method isEqualToString:kIQHTTPMethodPOST] || [method isEqualToString:kIQHTTPMethodPUT] || [method isEqualToString:kIQHTTPMethodDELETE])
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
                NSString *parameterString = [[self class] httpURLEncodedString:parameter];
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
    
    return [self requestWithURL:url httpMethod:method contentType:self.defaultContentType httpBody:httpBody dataCompletionHandler:completionHandler];
}


-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method contentType:(NSString*)contentType httpBody:(NSData*)httpBody completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    return [self requestWithPath:path httpMethod:method contentType:contentType httpBody:httpBody dataCompletionHandler:^(NSData *result, NSError *error) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];

        if (completionHandler)
        {
            completionHandler(dict,error);
        }
    }];
}

-(IQURLConnection*)requestWithPath:(NSString*)path httpMethod:(NSString*)method contentType:(NSString*)contentType httpBody:(NSData*)httpBody dataCompletionHandler:(IQDataCompletionBlock)completionHandler
{
    return [self requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",self.serverURL,path] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]] httpMethod:method contentType:contentType httpBody:httpBody dataCompletionHandler:completionHandler];
}


-(IQURLConnection*)requestWithURL:(NSURL*)url httpMethod:(NSString*)method contentType:(NSString*)contentType httpBody:(NSData*)httpBody dataCompletionHandler:(IQDataCompletionBlock)completionHandler
{
    NSMutableURLRequest *request = [IQWebService requestWithURL:url httpMethod:method contentType:contentType body:httpBody];
    
    //Adding headers
    {
        [request setAllHTTPHeaderFields:defaultHeaders];
    }
    
    if (_logEnabled)
	{
        [[self class] printHTTPRequest:request];
	}
    
    __block IQURLConnection *connection = [IQURLConnection sendAsynchronousRequest:request responseBlock:NULL uploadProgressBlock:NULL downloadProgressBlock:NULL completionHandler:^(NSData *result, NSError *error) {
        
        if (_logEnabled)
        {
            [[self class] printConnection:connection];
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

-(IQURLConnection*)fileUploadRequestWithPath:(NSString*)path parameter:(NSDictionary*)parameter uploadFiles:(NSArray*)files mimeType:(NSString*)mimeType uploadProgressBlock:(IQProgressBlock)uploadProgress responseBlock:(IQDictionaryCompletionBlock)completionHandler
{
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",self.serverURL,path] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:kIQHTTPMethodPOST];
    
    //Adding headers
    {
        [request setAllHTTPHeaderFields:defaultHeaders];
    }
    
    NSString *boundary = [[self class] generateBoundaryString];
    
    //Set Content-Type
    {
        NSString *contentType =[NSString stringWithFormat:@"%@; %@=%@",kIQContentTypeMultipartFormData, kIQContentTypeBoundary, boundary];
        [request setValue:contentType forHTTPHeaderField:kIQContentType];
    }
    
    //Set HTTPBody
    {
        NSMutableData *httpBody = [NSMutableData data];
        
        //Append Key-Value
        [parameter enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop)
         {
             [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
             [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
             [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
         }];
        
        // Append Data
        for (NSData *file in files)
        {
            NSString *fileName = nil;
            
            if      ([mimeType isEqualToString:(NSString*)kUTTypeJPEG])     fileName = @"selfie.jpg";
            else if ([mimeType isEqualToString:(NSString*)kUTTypeVideo])    fileName = @"selfie.mov";
            else    fileName = @"selfie";
            
            [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"selfie\"; filename=\"%@\"\r\n",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", kUTTypeJPEG] dataUsingEncoding:NSUTF8StringEncoding]];
            [httpBody appendData:file];
            [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        //Closing boundary
        [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        request.HTTPBody = httpBody;
        
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[httpBody length]] forHTTPHeaderField:@"Content-Length"];
    }
    
    if (_logEnabled)
	{
        [[self class] printHTTPRequest:request];
	}
    
    __block IQURLConnection *connection = [IQURLConnection sendAsynchronousRequest:request responseBlock:NULL uploadProgressBlock:uploadProgress downloadProgressBlock:NULL completionHandler:^(NSData *result, NSError *error) {
        
        if (_logEnabled)
        {
            [[self class] printConnection:connection];
        }
        
        if (completionHandler != NULL)
        {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(response, error);
            });
        }
    }];
    
    return connection;
}


#pragma mark -
#pragma mark - Synchronous Requests

-(NSDictionary*)synchronousRequestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter error:(NSError**)error
{
    NSData *data = [self synchronousDataRequestWithPath:path httpMethod:method parameter:parameter error:error];
    
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

-(NSData*)synchronousDataRequestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter error:(NSError**)error
{
    NSURL *url = nil;
    NSData *httpBody = nil;
    
    if ([method isEqualToString:kIQHTTPMethodGET])
    {
        NSMutableString *parameterString = [[NSMutableString alloc] init];
        if ([path hasSuffix:@"?"] == NO && [parameter count])
            [parameterString appendString:@"?"];
        
        [parameterString appendString:[[self class] httpURLEncodedString:parameter]];
        
        url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@%@",self.serverURL,path,parameterString] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    }
    else if ([method isEqualToString:kIQHTTPMethodPOST] || [method isEqualToString:kIQHTTPMethodPUT] || [method isEqualToString:kIQHTTPMethodDELETE])
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
                NSString *parameterString = [[self class] httpURLEncodedString:parameter];
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
    
    return [self synchronousRequestWithURL:url httpMethod:method contentType:self.defaultContentType httpBody:httpBody error:error];
}

-(NSDictionary*)synchronousRequestWithPath:(NSString*)path httpMethod:(NSString*)method contentType:(NSString*)contentType httpBody:(NSData*)httpBody error:(NSError**)error
{
    NSData *data = [self synchronousDataRequestWithPath:path httpMethod:method contentType:contentType httpBody:httpBody error:error];
    
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

-(NSData*)synchronousDataRequestWithPath:(NSString*)path httpMethod:(NSString*)method contentType:(NSString*)contentType httpBody:(NSData*)httpBody error:(NSError**)error
{
    return [self synchronousRequestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",self.serverURL,path] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]] httpMethod:method contentType:contentType httpBody:httpBody error:error];
}

-(NSData*)synchronousRequestWithURL:(NSURL*)url httpMethod:(NSString*)method contentType:(NSString*)contentType httpBody:(NSData*)httpBody error:(NSError**)error
{
    NSMutableURLRequest *request = [IQWebService requestWithURL:url httpMethod:method contentType:contentType body:httpBody];
    
    //Adding headers
    {
        [request setAllHTTPHeaderFields:defaultHeaders];
    }
    
    if (_logEnabled)
	{
        [[self class] printHTTPRequest:request];
	}
    
    return [IQURLConnection sendSynchronousRequest:request returningResponse:NULL error:error];
}

#pragma mark -
#pragma mark - Private Helper methods

+(void)printHTTPRequest:(NSURLRequest*)request
{
    if (request.URL == NULL)    NSLog(@"RequestURL is NULL");
    else                        NSLog(@"RequestURL:- %@",request.URL);
    
    NSLog(@"HTTP Method:- %@",request.HTTPMethod);
    
    if (request.allHTTPHeaderFields)
    {
        NSLog(@"HTTPHeaderFields:- %@",request.allHTTPHeaderFields);
    }
    
    if (request.HTTPBody)
    {
        NSString *requestString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        
        if (requestString)
        {
            NSLog(@"Request Body:- %@\n\n",requestString);
        }
        else
        {
            NSLog(@"Request Body Length:- %d\n\n",[request.HTTPBody length]);
        }
    }
}

+(void)printConnection:(IQURLConnection*)connection
{
    NSLog(@"URL:- %@",connection.originalRequest.URL);
    NSLog(@"HTTP Method:- %@",connection.originalRequest.HTTPMethod);
    
    if (connection.error)
    {
        NSLog(@"error:- %@\n\n",connection.error);
    }
    
    if (connection.response)
    {
        NSLog(@"Response Header:- %@\n\n",connection.response.allHeaderFields);
    }
    
    if (connection.responseData)
    {
        NSString *responseString = [[NSString alloc] initWithData:connection.responseData encoding:NSUTF8StringEncoding];
        
        if ([responseString length])
        {
            NSLog(@"Response:- %@\n\n",responseString);
        }
        else
        {
            NSLog(@"Response Data Length:- %d\n\n",[connection.responseData length]);
        }
    }
}


+(NSString*)httpURLEncodedString:(NSDictionary*)dictionary
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

// generate boundary string
// adapted from http://developer.apple.com/library/ios/#samplecode/SimpleURLConnections
+ (NSString *)generateBoundaryString
{
    CFUUIDRef       uuid;
    CFStringRef     uuidStr;
    NSString *      result;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

+ (NSString *)contentTypeForImageData:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

@end


