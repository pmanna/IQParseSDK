//
//  IQ_PFQuery.m
//  IQParseSDK
//
//  Created by Mohd Iftekhar Qurashi on 08/09/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import "IQ_PFQuery.h"
#import "IQ_PFWebService.h"

#import <Foundation/NSDictionary.h>
#import <Foundation/NSString.h>

@implementation IQ_PFQuery

//+(IQ_PFQuery *)queryWithClassName:(NSString *)className
//{
//    IQ_PFQuery *query = [[self alloc] init];
//    query.parseClassName = className;
//
//    return query;
//}
//
//- (void)findObjectsInBackgroundWithBlock:(IQ_PFArrayResultBlock)block
//{
//    [[IQ_PFWebService service] path:[NSString stringWithFormat:@"classes/%@",_parseClassName] method:IQ_HTTPMethodGET completionHandler:^(NSDictionary *dict, NSError *error) {
//        
//        block([dict objectForKey:@"results"],error);
//   }];
//}


+(NSDictionary*)whereGreaterThan:(id)greaterValue lessThan:(id)lessThanValue
{
    NSMutableDictionary *dictWhere = [[NSMutableDictionary alloc] init];
    
    if (greaterValue)
    {
        [dictWhere setObject:greaterValue forKey:kParseGreaterThanKey];
    }
    
    if (lessThanValue)
    {
        [dictWhere setObject:lessThanValue forKey:kParseLessThanKey];
    }
    
    return dictWhere;
}

+(NSDictionary*)whereContainedIn:(NSArray*)array
{
    return @{kParseContainedInKey: array};
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

@end
