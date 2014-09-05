//
//  IQ_PFWebService.h
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


#import "IQWebService.h"
#import "IQ_PFWebServiceConstants.h"

@interface IQ_PFWebService : IQWebService

//Get
-(IQURLConnection*)objectsWithParseClass:(NSString*)parseClassName urlParameter:(NSDictionary*)urlParameter completionHandler:(IQDictionaryCompletionBlock)completion;
-(IQURLConnection*)objectsWithParseClass:(NSString*)parseClassName urlParameter:(NSDictionary*)urlParameter objectId:(NSString*)objectId completionHandler:(IQDictionaryCompletionBlock)completion;

//Create
-(IQURLConnection*)createObjectWithParseClass:(NSString*)parseClassName attributes:(NSDictionary*)attributes completionHandler:(IQDictionaryCompletionBlock)completion;

//Edit
-(IQURLConnection*)updateObjectWithParseClass:(NSString*)parseClassName objectId:(NSString*)objectId attributes:(NSDictionary*)attributes completionHandler:(IQDictionaryCompletionBlock)completion;

//Delete
-(IQURLConnection*)deleteObjectWithParseClass:(NSString*)parseClassName objectId:(NSString*)objectId completionHandler:(IQDictionaryCompletionBlock)completion;
-(IQURLConnection*)deleteField:(NSString*)fieldName WithParseClass:(NSString*)parseClassName objectId:(NSString*)objectId completionHandler:(IQDictionaryCompletionBlock)completion;

-(IQURLConnection*)performBatchOperations:(NSArray*)operations completionHandler:(IQDictionaryCompletionBlock)completion;

//Query
-(IQURLConnection*)queryWithParseClass:(NSString*)parseClassName query:(NSDictionary*)query completionHandler:(IQDictionaryCompletionBlock)completion;


//Parse Function
-(IQURLConnection*)callFunction:(NSString*)function withParameters:(NSDictionary *)parameters completionHandler:(IQDictionaryCompletionBlock)completion;


//File
-(IQURLConnection*)saveFileData:(NSData*)data fileName:(NSString*)fileName contentType:(NSString*)contentType uploadProgressBlock:(IQProgressBlock)uploadProgress completionHandler:(IQDictionaryCompletionBlock)completion;
-(IQURLConnection*)getDataWithFileUrl:(NSURL*)url downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDataCompletionBlock)completion;


/*------------------------------------------------*/
//Batch operation creation
+(NSDictionary*)batchOperationWithMethod:(NSString*)method path:(NSString*)path body:(NSDictionary*)body;

@end








