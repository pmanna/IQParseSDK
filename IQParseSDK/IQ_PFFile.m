//
//  IQ_PFFile.m
//  IQParseSDK
//
//  Created by Iftekhar on 07/10/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import "IQ_PFFile.h"
#import "IQ_PFWebService.h"

#import <Foundation/NSData.h>
#import <Foundation/NSDictionary.h>


@implementation IQ_PFFile
{
//	NSData *_data;
//	NSString *_localName;
}

//@synthesize name = _name;
//@synthesize url = _url;
//
//
//-(void)setData:(NSData*)data
//{
//	_data = data;
//}
//
//- (NSData *)getData
//{
//	return _data;
//}
//
//-(void)setLocalName:(NSString*)name
//{
//	_localName = name;
//}
//
//- (id)init
//{
//    self = [super init];
//    if (self) {
//        _localName = @"pic.jpg";
//    }
//    return self;
//}
//
//
//+ (id)fileWithData:(NSData *)data
//{
//	IQ_PFFile *file = [[IQ_PFFile alloc] init];
//	[file setData:data];
//	
//	return file;
//}
//
//+ (id)fileWithName:(NSString *)name data:(NSData *)data
//{
//	IQ_PFFile *file = [IQ_PFFile fileWithData:data];
//	[file setLocalName:name];
//    
//	return file;
//}
//
//
//+ (id)fileWithName:(NSString *)name contentsAtPath:(NSString *)path
//{
//	IQ_PFFile *file = [IQ_PFFile fileWithName:name data:[NSData dataWithContentsOfFile:path]];
//	return file;
//}
//
//- (void)saveInBackground
//{
//	[self saveInBackgroundWithBlock:NULL];
//}
//
//- (void)saveInBackgroundWithBlock:(IQ_PFFileResultBlock)block
//{
//    [[IQ_PFWebService service] saveData:_data fileName:_localName contentType:@"image/jpeg" completionHandler:^(NSDictionary *dict, NSError *error) {
//        
//        if (dict)
//        {
//            _url	= [dict objectForKey:@"url"];
//            _name	= [dict objectForKey:@"name"];
//            
//            if (block)	block(dict , NULL);
//        }
//        else
//        {
//            if (block)	block(nil , error);
//        }
//    }];
//}

@end
