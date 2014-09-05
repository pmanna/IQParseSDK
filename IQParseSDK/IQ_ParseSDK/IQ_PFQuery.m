//
//  IQ_PFQuery.m
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

#import "IQ_PFQuery.h"
#import "IQ_PFWebService.h"
#import "IQ_PFObject.h"
#import "IQURLConnection.h"

#import <Foundation/NSDictionary.h>
#import <Foundation/NSString.h>

@implementation IQ_PFQuery
{
    NSMutableDictionary *_queryDictionary;

    NSMutableString *_orderByString;
    
    NSMutableSet *connectionSet;
}

-(void)updateQueryDict:(NSDictionary*)queryDict forKey:(NSString*)key
{
    if ([[_queryDictionary objectForKey:key] isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *dict = [[_queryDictionary objectForKey:key] mutableCopy];
        [dict addEntriesFromDictionary:queryDict];
        
        [_queryDictionary setObject:dict forKey:key];
    }
    else
    {
        [_queryDictionary setObject:queryDict forKey:key];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _queryDictionary = [[NSMutableDictionary alloc] init];
        self.limit = -1;
        self.skip = 0;
        _orderByString = [[NSMutableString alloc] init];
    }
    return self;
}

+ (IQ_PFQuery *)queryWithClassName:(NSString *)className
{
    return [[self alloc] initWithClassName:className];
}

//+ (IQ_PFQuery *)queryWithClassName:(NSString *)className predicate:(NSPredicate *)predicate;

- (instancetype)initWithClassName:(NSString *)newClassName
{
    self = [self init];
    if (self)
    {
        self.parseClassName = newClassName;
    }
    return self;
}

//- (void)includeKey:(NSString *)key;
//- (void)selectKeys:(NSArray *)keys;

- (void)whereKeyExists:(NSString *)key
{
    NSDictionary *existDict = [[self class] whereExist:YES];
    
    [self updateQueryDict:existDict forKey:key];
}

- (void)whereKeyDoesNotExist:(NSString *)key
{
    NSDictionary *notExistDict = [[self class] whereExist:NO];
    
    [self updateQueryDict:notExistDict forKey:key];
}

- (void)whereKey:(NSString *)key equalTo:(id)object
{
    [_queryDictionary setObject:object forKey:key];
}

- (void)whereKey:(NSString *)key lessThan:(id)object
{
    NSDictionary *lessThanDict = [[self class] whereLessThan:object];
    
    [self updateQueryDict:lessThanDict forKey:key];
}

- (void)whereKey:(NSString *)key lessThanOrEqualTo:(id)object
{
    NSDictionary *lessThanOrEqualDict = [[self class] whereLessThanOrEqual:object];
    
    [self updateQueryDict:lessThanOrEqualDict forKey:key];
}

- (void)whereKey:(NSString *)key greaterThan:(id)object
{
    NSDictionary *greaterThanDict = [[self class] whereGreaterThan:object];
    
    [self updateQueryDict:greaterThanDict forKey:key];
}

- (void)whereKey:(NSString *)key greaterThanOrEqualTo:(id)object
{
    NSDictionary *greaterThanOrEqualDict = [[self class] whereGreaterThanOrEqual:object];
    
    [self updateQueryDict:greaterThanOrEqualDict forKey:key];
}

- (void)whereKey:(NSString *)key notEqualTo:(id)object
{
    NSDictionary *notEqualDict = [[self class] whereNotEqual:object];
    
    [self updateQueryDict:notEqualDict forKey:key];
}

- (void)whereKey:(NSString *)key containedIn:(NSArray *)array
{
    NSDictionary *containedInDict = [[self class] whereContainedIn:array];
    
    [self updateQueryDict:containedInDict forKey:key];
}

- (void)whereKey:(NSString *)key notContainedIn:(NSArray *)array
{
    NSDictionary *notContainedInDict = [[self class] whereNotContainedIn:array];
    
    [self updateQueryDict:notContainedInDict forKey:key];
}

//- (void)whereKey:(NSString *)key containsAllObjectsInArray:(NSArray *)array;
//- (void)whereKey:(NSString *)key nearGeoPoint:(IQ_PFGeoPoint *)geopoint;
//- (void)whereKey:(NSString *)key nearGeoPoint:(IQ_PFGeoPoint *)geopoint withinMiles:(double)maxDistance;
//- (void)whereKey:(NSString *)key nearGeoPoint:(IQ_PFGeoPoint *)geopoint withinKilometers:(double)maxDistance;
//- (void)whereKey:(NSString *)key nearGeoPoint:(IQ_PFGeoPoint *)geopoint withinRadians:(double)maxDistance;
//- (void)whereKey:(NSString *)key withinGeoBoxFromSouthwest:(IQ_PFGeoPoint *)southwest toNortheast:(IQ_PFGeoPoint *)northeast;
//- (void)whereKey:(NSString *)key matchesRegex:(NSString *)regex;
//- (void)whereKey:(NSString *)key matchesRegex:(NSString *)regex modifiers:(NSString *)modifiers;
//- (void)whereKey:(NSString *)key containsString:(NSString *)substring;
//- (void)whereKey:(NSString *)key hasPrefix:(NSString *)prefix;
//- (void)whereKey:(NSString *)key hasSuffix:(NSString *)suffix;
//+ (IQ_PFQuery *)orQueryWithSubqueries:(NSArray *)queries;
//- (void)whereKey:(NSString *)key matchesKey:(NSString *)otherKey inQuery:(IQ_PFQuery *)query;
//- (void)whereKey:(NSString *)key doesNotMatchKey:(NSString *)otherKey inQuery:(IQ_PFQuery *)query;
//- (void)whereKey:(NSString *)key matchesQuery:(IQ_PFQuery *)query;
//- (void)whereKey:(NSString *)key doesNotMatchQuery:(IQ_PFQuery *)query;

- (void)orderByAscending:(NSString *)key
{
    _orderByString = [[NSMutableString alloc] initWithString:key];
}

- (void)addAscendingOrder:(NSString *)key
{
    [_orderByString appendFormat:@",%@",key];
}

- (void)orderByDescending:(NSString *)key
{
    _orderByString = [[NSMutableString alloc] initWithFormat:@"-%@",key];
}

- (void)addDescendingOrder:(NSString *)key
{
    [_orderByString appendFormat:@",-%@",key];
}

//- (void)orderBySortDescriptor:(NSSortDescriptor *)sortDescriptor;
//
//+ (IQ_PFObject *)getObjectOfClass:(NSString *)objectClass objectId:(NSString *)objectId;
//+ (IQ_PFObject *)getObjectOfClass:(NSString *)objectClass objectId:(NSString *)objectId error:(NSError **)error;
//- (IQ_PFObject *)getObjectWithId:(NSString *)objectId;
//- (IQ_PFObject *)getObjectWithId:(NSString *)objectId error:(NSError **)error;

- (void)getObjectInBackgroundWithId:(NSString *)objectId block:(IQ_PFObjectResultBlock)block
{
    IQURLConnection *connection = [[IQ_PFWebService service] objectsWithParseClass:self.parseClassName urlParameter:nil objectId:objectId completionHandler:^(NSDictionary *result, NSError *error) {

        [connectionSet removeObject:connection];

        if (block)
        {
            IQ_PFObject *object = [IQ_PFObject objectWithClassName:self.parseClassName dictionary:result];
            
            block(object,error);
        }
    }];
    
    [connectionSet addObject:connection];
}

- (void)getObjectInBackgroundWithId:(NSString *)objectId target:(id)target selector:(SEL)selector
{
    [self getObjectInBackgroundWithId:objectId block:^(IQ_PFObject *object, NSError *error) {
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
        [invocation setArgument:&object atIndex:2];
        [invocation setArgument:&error atIndex:3];
        [invocation invoke];
    }];
}

//+ (IQ_PFUser *)getUserObjectWithId:(NSString *)objectId;
//+ (IQ_PFUser *)getUserObjectWithId:(NSString *)objectId error:(NSError **)error;
//
//- (NSArray *)findObjects;
//- (NSArray *)findObjects:(NSError **)error;

- (void)findObjectsInBackgroundWithBlock:(IQ_PFArrayResultBlock)block
{
    NSMutableDictionary *queryDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_queryDictionary,kParseWhereKey, nil];
    
    if (self.limit >=0)
    {
        [queryDict setObject:[NSNumber numberWithInteger:self.limit] forKey:kParseLimitKey];
    }
    
    if (self.skip > 0)
    {
        [queryDict setObject:[NSNumber numberWithInteger:self.skip] forKey:kParseSkipKey];
    }
    
    if ([_orderByString length])
    {
        [queryDict setObject:_orderByString forKey:kParseOrderKey];
    }
    
    IQURLConnection *connection = [[IQ_PFWebService service] queryWithParseClass:self.parseClassName query:queryDict completionHandler:^(NSDictionary *result, NSError *error) {

        [connectionSet removeObject:connection];

        if (block)
        {
            block([result objectForKey:kParseResultsKey],error);
        }
    }];
    
    [connectionSet addObject:connection];
}

- (void)findObjectsInBackgroundWithTarget:(id)target selector:(SEL)selector
{
    [self findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
        [invocation setArgument:&objects atIndex:2];
        [invocation setArgument:&error atIndex:3];
        [invocation invoke];
        
    }];
}

//- (IQ_PFObject *)getFirstObject;
//- (IQ_PFObject *)getFirstObject:(NSError **)error;

- (void)getFirstObjectInBackgroundWithBlock:(IQ_PFObjectResultBlock)block
{
    NSDictionary *queryDict = @{kParseWhereKey: _queryDictionary,kParseSkipKey:@(self.skip),kParseLimitKey:@1};

    IQURLConnection *connection = [[IQ_PFWebService service] queryWithParseClass:self.parseClassName query:queryDict completionHandler:^(NSDictionary *result, NSError *error) {
        
        [connectionSet removeObject:connection];

        if (block)
        {
            NSDictionary *objectDict = [[result objectForKey:kParseResultsKey] firstObject];
            
            IQ_PFObject *object = [IQ_PFObject objectWithClassName:self.parseClassName dictionary:objectDict];
            
            block(object,error);
        }
    }];
    
    [connectionSet addObject:connection];
}

- (void)getFirstObjectInBackgroundWithTarget:(id)target selector:(SEL)selector
{
    [self getFirstObjectInBackgroundWithBlock:^(IQ_PFObject *object, NSError *error) {
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
        [invocation setArgument:&object atIndex:2];
        [invocation setArgument:&error atIndex:3];
        [invocation invoke];

    }];
}

//- (NSInteger)countObjects;
//- (NSInteger)countObjects:(NSError **)error;

- (void)countObjectsInBackgroundWithBlock:(IQ_PFIntegerResultBlock)block
{
    NSDictionary *queryDict = @{kParseWhereKey: _queryDictionary,kParseCountKey:@(YES),kParseSkipKey:@(self.skip),kParseLimitKey:@0};

    IQURLConnection *connection = [[IQ_PFWebService service] queryWithParseClass:self.parseClassName query:queryDict completionHandler:^(NSDictionary *result, NSError *error) {
        
        [connectionSet removeObject:connection];

        if (block)
        {
            block([[result objectForKey:kParseCountKey] intValue],error);
        }
    }];
    
    [connectionSet addObject:connection];
}

- (void)countObjectsInBackgroundWithTarget:(id)target selector:(SEL)selector
{
    [self countObjectsInBackgroundWithBlock:^(int number, NSError *error) {

        NSNumber *countNumber = [NSNumber numberWithInt:number];
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
        [invocation setArgument:&countNumber atIndex:2];
        [invocation setArgument:&error atIndex:3];
        [invocation invoke];
    }];
}

- (void)cancel
{
    while ([connectionSet count])
    {
        IQURLConnection *connection = [connectionSet anyObject];
        [connection cancel];
        [connectionSet removeObject:connection];
    }
}

//@property (assign, readwrite) IQ_PFCachePolicy cachePolicy;
//@property (assign, readwrite) NSTimeInterval maxCacheAge;

//- (BOOL)hasCachedResult;
//- (void)clearCachedResult;
//+ (void)clearAllCachedResults;

//@property (nonatomic, assign) BOOL trace;


+(NSDictionary*)whereLessThan:(id)lessThanValue
{
    return @{kParseLessThanKey: lessThanValue};
}

+(NSDictionary*)whereLessThanOrEqual:(id)lessThanOrEqualValue
{
    return @{kParseLessThanOrEqualKey: lessThanOrEqualValue};
}

+(NSDictionary*)whereGreaterThan:(id)greaterThanValue
{
    return @{kParseGreaterThanKey: greaterThanValue};
}

+(NSDictionary*)whereGreaterThanOrEqual:(id)greaterThanOrEqualValue
{
    return @{kParseGreaterThanOrEqualKey: greaterThanOrEqualValue};
}

+(NSDictionary*)whereNotEqual:(id)noEqualValue
{
    return @{kParseNotEqualKey: noEqualValue};
}

+(NSDictionary*)whereContainedIn:(NSArray*)array
{
    return @{kParseContainedInKey: array};
}

+(NSDictionary*)whereNotContainedIn:(NSArray*)array
{
    return @{kParseNotContainedInKey: array};
}

+(NSDictionary*)whereExist:(BOOL)exist
{
    return @{kParseExistsKey: @(exist)};
}

+(NSDictionary*)whereSelectQuery:(NSDictionary*)query forKey:(NSString*)key
{
    if (key)
    {
        return @{kParseSelectKey: @{kParseQueryKey: query, kParseKeyKey: key}};
    }
    else
    {
        return @{kParseSelectKey: @{kParseQueryKey: query}};
    }
}

/*
 NSString *const kParseSelectKey                 =   @"$select";
 NSString *const kParseDontSelectKey             =   @"$dontSelect";
 NSString *const kParseAllKey                    =   @"$all";
 */

@end
