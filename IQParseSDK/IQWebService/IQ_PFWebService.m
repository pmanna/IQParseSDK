//
//  MyWebService.m
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

-(void)objectsWithParseClass:(NSString*)parseClassName urlParameter:(NSDictionary*)urlParameter completionHandler:(IQDictionaryCompletionBlock)completion
{
    [self objectsWithParseClass:parseClassName urlParameter:urlParameter objectId:nil completionHandler:completion];
}

-(void)objectsWithParseClass:(NSString*)parseClassName urlParameter:(NSDictionary*)urlParameter objectId:(NSString*)objectId completionHandler:(IQDictionaryCompletionBlock)completion
{
    NSMutableString *path = [[NSMutableString alloc] initWithFormat:@"classes/%@",parseClassName];
    
    if (urlParameter)
    {
        NSString *httpParameterString = [[self class] httpParameterString:urlParameter];
        [path appendFormat:@"?%@",httpParameterString];
    }
    
    if (objectId)   [path appendFormat:@"/%@",objectId];
    
    [self requestWithPath:path httpMethod:kIQHTTPMethodGET parameter:nil completionHandler:completion];
}

-(void)createObjectWithParseClass:(NSString*)parseClassName attributes:(NSDictionary*)attributes completionHandler:(IQDictionaryCompletionBlock)completion
{
    NSMutableString *path = [[NSMutableString alloc] initWithFormat:@"classes/%@",parseClassName];
    
    [self requestWithPath:path httpMethod:kIQHTTPMethodPOST parameter:attributes completionHandler:completion];
}

-(void)updateObjectWithParseClass:(NSString*)parseClassName objectId:(NSString*)objectId attributes:(NSDictionary*)attributes completionHandler:(IQDictionaryCompletionBlock)completion
{
    NSMutableString *path = [[NSMutableString alloc] initWithFormat:@"classes/%@/%@",parseClassName,objectId];
    
    [self requestWithPath:path httpMethod:kIQHTTPMethodPUT parameter:attributes completionHandler:completion];
}

-(void)deleteObjectWithParseClass:(NSString*)parseClassName objectId:(NSString*)objectId completionHandler:(IQDictionaryCompletionBlock)completion
{
    NSMutableString *path = [[NSMutableString alloc] initWithFormat:@"classes/%@",parseClassName];
    
    if (objectId)   [path appendFormat:@"/%@",objectId];
    
    [self requestWithPath:path httpMethod:kIQHTTPMethodDELETE parameter:nil completionHandler:completion];
}

-(void)deleteField:(NSString*)fieldName WithParseClass:(NSString*)parseClassName objectId:(NSString*)objectId completionHandler:(IQDictionaryCompletionBlock)completion
{
    NSMutableString *path = [[NSMutableString alloc] initWithFormat:@"classes/%@",parseClassName];
    
    if (objectId)   [path appendFormat:@"/%@",objectId];
    
    NSDictionary *deleteFieldDict = @{fieldName: [[self class] deleteFieldAttribute]};
    
    [self requestWithPath:path httpMethod:kIQHTTPMethodPUT parameter:deleteFieldDict completionHandler:completion];
}

-(void)performBatchOperations:(NSArray*)operations completionHandler:(IQDictionaryCompletionBlock)completion
{
    NSDictionary *dictRequests = @{kParseRequestsKey: operations};
    
    [self requestWithPath:@"batch" httpMethod:kIQHTTPMethodPOST parameter:dictRequests completionHandler:completion];
}


#pragma mark -
#pragma mark - Queries

-(void)queryWithParseClass:(NSString*)parseClassName query:(NSDictionary*)query completionHandler:(IQDictionaryCompletionBlock)completion
{
    NSData *queryData = [NSJSONSerialization dataWithJSONObject:query options:0 error:nil];
    NSString *queryString = [[NSString alloc] initWithData:queryData encoding:NSASCIIStringEncoding];

    NSDictionary *dict = @{@"where": queryString};

    [self objectsWithParseClass:parseClassName urlParameter:dict completionHandler:completion];
}


#pragma mark -
#pragma mark - Cloud Code

-(void)callFunction:(NSString*)function withParameters:(NSDictionary *)parameters completionHandler:(IQDictionaryCompletionBlock)completion
{
    NSMutableString *path = [[NSMutableString alloc] initWithFormat:@"functions/%@",function];

    [self requestWithPath:path httpMethod:kIQHTTPMethodPOST parameter:parameters completionHandler:completion];
}


#pragma mark -
#pragma mark - Helper

+(NSDictionary*)batchOperationWithMethod:(NSString*)method path:(NSString*)path body:(NSDictionary*)body
{
    return @{kParseMethodKey: method, kParsePathKey: path, kParseBodyKey:body};
}

+(NSDictionary*)deleteFieldAttribute
{
    return @{kParse__OpKey:@"Delete"};
}


//+(NSDictionary*)addRelationAttribute
//{
//    /*
//     curl -X PUT \
//     -H "X-Parse-Application-Id: kk7wtCOCuafGq4EuSZXKy66RuUKBHjUYrJlDp0d7" \
//     -H "X-Parse-REST-API-Key: jBPJ9swSZq97gmXqDNG1Gm57XBG0cSdC3smdIHdJ" \
//     -H "Content-Type: application/json" \
//     -d '{"opponents":{"__op":"AddRelation","objects":[{"__type":"Pointer","className":"Player","objectId":"Vx4nudeWn"}]}}' \
//     https://api.parse.com/1/classes/GameScore/Ed1nuqPvcm
//     Show examples for:  Use keys for:
//     To remove an object from a relation, you can do:
//     */    return nil;
//}
//
//+(NSDictionary*)removeRelationAttribute
//{
//    /*
//     curl -X PUT \
//     -H "X-Parse-Application-Id: kk7wtCOCuafGq4EuSZXKy66RuUKBHjUYrJlDp0d7" \
//     -H "X-Parse-REST-API-Key: jBPJ9swSZq97gmXqDNG1Gm57XBG0cSdC3smdIHdJ" \
//     -H "Content-Type: application/json" \
//     -d '{"opponents":{"__op":"RemoveRelation","objects":[{"__type":"Pointer","className":"Player","objectId":"Vx4nudeWn"}]}}' \
//     https://api.parse.com/1/classes/GameScore/Ed1nuqPvcm
//     */    return nil;
//}

@end


/*
 Quick Reference
 
 All API access is over HTTPS, and accessed via the https://api.parse.com domain. The relative path prefix /1/ indicates that we are currently using version 1 of the API.
 
 Objects
 
 URL	HTTP Verb	Functionality
 /1/classes/<className>	GET	Queries
 /1/classes/<className>/<objectId>	DELETE	Deleting Objects
 Users
 
 URL	HTTP Verb	Functionality
 /1/users	POST	Signing Up
 Linking Users
 /1/login	GET	Logging In
 /1/users/<objectId>	GET	Retrieving Users
 /1/users/me	GET	Validating Session Tokens
 Retrieving Current User
 /1/users/<objectId>	PUT	Updating Users
 Linking Users
 Verifying Emails
 /1/users	GET	Querying Users
 /1/users/<objectId>	DELETE	Deleting Users
 /1/requestPasswordReset	POST	Requesting A Password Reset
 Roles
 
 URL	HTTP Verb	Functionality
 /1/roles	POST	Creating Roles
 /1/roles/<objectId>	GET	Retrieving Roles
 /1/roles/<objectId>	PUT	Updating Roles
 /1/roles	GET	Querying Roles
 /1/roles/<objectId>	DELETE	Deleting Roles
 Files
 
 URL	HTTP Verb	Functionality
 /1/files/<fileName>	POST	Uploading Files
 Analytics
 
 URL	HTTP Verb	Functionality
 /1/events/AppOpened	POST	Analytics
 /1/events/<eventName>	POST	Custom Analytics
 Push Notifications
 
 URL	HTTP Verb	Functionality
 /1/push	POST	Push Notifications
 Installations
 
 URL	HTTP Verb	Functionality
 /1/installations	POST	Uploading Installation Data
 /1/installations/<objectId>	GET	Retrieving Installations
 /1/installations/<objectId>	PUT	Updating Installations
 /1/installations	GET	Querying Installations
 /1/installations/<objectId>	DELETE	Deleting Installations
 Cloud Functions
 
 URL	HTTP Verb	Functionality
 /1/functions	POST	Calling Cloud Functions
 /1/jobs	POST	Triggering Background Jobs
 
 */


















