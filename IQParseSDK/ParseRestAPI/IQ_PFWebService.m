//
//  IQ_PFWebService.m
// https://github.com/hackiftekhar/IQParseSDK
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


#import "IQ_PFWebService.h"
#import "IQ_Parse.h"

@implementation IQ_PFWebService

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setLogEnabled:YES];
        [self setParameterType:IQRequestParameterTypeApplicationJSON];
        [self setServerURL:@"https://api.parse.com/1/"];

        [self setDefaultContentType:kIQContentTypeApplicationJson];

        [self addDefaultHeaderValue:[IQ_Parse getApplicationId] forHeaderField:kParse_X_Parse_Application_Id];
        [self addDefaultHeaderValue:[IQ_Parse getRestAPIKey] forHeaderField:kParse_X_Parse_REST_API_Key];
//        [self addDefaultHeaderValue:kIQContentTypeApplicationJson forHeaderField:kIQAccept];
    }
    return self;
}

#pragma mark -
#pragma mark - Objects

-(IQURLConnection*)objectsWithParseClass:(NSString*)parseClassName urlParameter:(NSDictionary*)urlParameter completionHandler:(IQDictionaryCompletionBlock)completion
{
    return [self objectsWithParseClass:parseClassName urlParameter:urlParameter objectId:nil completionHandler:completion];
}

-(IQURLConnection*)objectsWithParseClass:(NSString*)parseClassName urlParameter:(NSDictionary*)urlParameter objectId:(NSString*)objectId completionHandler:(IQDictionaryCompletionBlock)completion
{
    NSMutableString *path = [[NSMutableString alloc] initWithFormat:@"classes/%@",parseClassName];
    
    if (urlParameter)
    {
        NSString *httpParameterString = [[self class] httpParameterString:urlParameter];
        [path appendFormat:@"?%@",httpParameterString];
    }
    
    if (objectId)   [path appendFormat:@"/%@",objectId];
    
    return [self requestWithPath:path httpMethod:kIQHTTPMethodGET parameter:nil completionHandler:completion];
}

-(IQURLConnection*)createObjectWithParseClass:(NSString*)parseClassName attributes:(NSDictionary*)attributes completionHandler:(IQDictionaryCompletionBlock)completion
{
    NSMutableString *path = [[NSMutableString alloc] initWithFormat:@"classes/%@",parseClassName];
    
    return [self requestWithPath:path httpMethod:kIQHTTPMethodPOST parameter:attributes completionHandler:completion];
}

-(IQURLConnection*)updateObjectWithParseClass:(NSString*)parseClassName objectId:(NSString*)objectId attributes:(NSDictionary*)attributes completionHandler:(IQDictionaryCompletionBlock)completion
{
    NSMutableString *path = [[NSMutableString alloc] initWithFormat:@"classes/%@/%@",parseClassName,objectId];
    
    return [self requestWithPath:path httpMethod:kIQHTTPMethodPUT parameter:attributes completionHandler:completion];
}

-(IQURLConnection*)deleteObjectWithParseClass:(NSString*)parseClassName objectId:(NSString*)objectId completionHandler:(IQDictionaryCompletionBlock)completion
{
    NSMutableString *path = [[NSMutableString alloc] initWithFormat:@"classes/%@",parseClassName];
    
    if (objectId)   [path appendFormat:@"/%@",objectId];
    
    return [self requestWithPath:path httpMethod:kIQHTTPMethodDELETE parameter:nil completionHandler:completion];
}

-(IQURLConnection*)deleteField:(NSString*)fieldName WithParseClass:(NSString*)parseClassName objectId:(NSString*)objectId completionHandler:(IQDictionaryCompletionBlock)completion
{
    NSMutableString *path = [[NSMutableString alloc] initWithFormat:@"classes/%@",parseClassName];
    
    if (objectId)   [path appendFormat:@"/%@",objectId];
    
    NSDictionary *deleteFieldDict = @{fieldName: [[self class] deleteFieldAttribute]};
    
    return [self requestWithPath:path httpMethod:kIQHTTPMethodPUT parameter:deleteFieldDict completionHandler:completion];
}

-(IQURLConnection*)performBatchOperations:(NSArray*)operations completionHandler:(IQDictionaryCompletionBlock)completion
{
    NSDictionary *dictRequests = @{kParseRequestsKey: operations};
    
    return [self requestWithPath:@"batch" httpMethod:kIQHTTPMethodPOST parameter:dictRequests completionHandler:completion];
}


#pragma mark -
#pragma mark - Queries

-(IQURLConnection*)queryWithParseClass:(NSString*)parseClassName query:(NSDictionary*)query completionHandler:(IQDictionaryCompletionBlock)completion
{
    return [self objectsWithParseClass:parseClassName urlParameter:query completionHandler:completion];
}


#pragma mark -
#pragma mark - Cloud Code

-(IQURLConnection*)callFunction:(NSString*)function withParameters:(NSDictionary *)parameters completionHandler:(IQDictionaryCompletionBlock)completion
{
    NSMutableString *path = [[NSMutableString alloc] initWithFormat:@"functions/%@",function];

    return [self requestWithPath:path httpMethod:kIQHTTPMethodPOST parameter:parameters completionHandler:completion];
}


#pragma mark -
#pragma mark - Files

-(IQURLConnection*)saveFileData:(NSData*)data fileName:(NSString*)fileName contentType:(NSString*)contentType uploadProgressBlock:(IQProgressBlock)uploadProgress completionHandler:(IQDictionaryCompletionBlock)completion
{
    NSMutableString *path = [[NSMutableString alloc] initWithFormat:@"files/%@",fileName];

    return [self requestWithPath:path httpMethod:kIQHTTPMethodPOST contentType:contentType httpBody:data responseBlock:nil uploadProgressBlock:uploadProgress downloadProgressBlock:nil completionHandler:completion];
}

-(IQURLConnection*)getDataWithFileUrl:(NSURL*)url downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDataCompletionBlock)completion
{
    return [self requestWithURL:url httpMethod:kIQHTTPMethodGET contentType:nil httpBody:nil responseBlock:nil uploadProgressBlock:nil downloadProgressBlock:downloadProgress dataCompletionHandler:completion];
}


#pragma mark -
#pragma mark - Helper

+(NSDictionary*)deleteFieldAttribute
{
    return @{kParse__OpKey:@"Delete"};
}




@end

