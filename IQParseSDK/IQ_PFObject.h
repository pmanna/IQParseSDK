//
//  IQ_PFObject.h
//  IQParseSDK
//
//  Created by lucho on 8/28/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import <Foundation/NSObject.h>
#import "IQ_PFConstants.h"

@class NSMutableDictionary,NSDateFormatter,NSDate;
@class IQ_PFACL, IQ_PFRelation;

@interface IQ_PFObject : NSObject

+ (instancetype)objectWithClassName:(NSString *)className;
+ (instancetype)objectWithoutDataWithClassName:(NSString *)className objectId:(NSString *)objectId;
+ (instancetype)objectWithClassName:(NSString *)className dictionary:(NSDictionary *)dictionary;

- (instancetype)initWithClassName:(NSString *)newClassName;
- (instancetype)initWithClassName:(NSString *)newClassName dictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong, readonly) NSString *parseClassName;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong, readonly) NSDate *updatedAt;
@property (nonatomic, strong, readonly) NSDate *createdAt;
//@property (nonatomic, strong) IQ_PFACL *ACL;

- (NSArray *)allKeys;

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

//- (IQ_PFRelation *)relationForKey:(NSString *)key;

- (void)addObject:(id)object forKey:(NSString *)key;
- (void)addObjectsFromArray:(NSArray *)objects forKey:(NSString *)key;
- (void)addUniqueObject:(id)object forKey:(NSString *)key;
- (void)addUniqueObjectsFromArray:(NSArray *)objects forKey:(NSString *)key;
- (void)removeObject:(id)object forKey:(NSString *)key;
- (void)removeObjectsInArray:(NSArray *)objects forKey:(NSString *)key;

- (void)incrementKey:(NSString *)key;
- (void)incrementKey:(NSString *)key byAmount:(NSNumber *)amount;

//- (BOOL)save;
//- (BOOL)save:(NSError **)error;
- (void)saveInBackground;
- (void)saveInBackgroundWithBlock:(IQ_PFBooleanResultBlock)block;
- (void)saveInBackgroundWithTarget:(id)target selector:(SEL)selector;
//- (void)saveEventually;
//- (void)saveEventually:(IQ_PFBooleanResultBlock)callback;

//+ (BOOL)saveAll:(NSArray *)objects;
//+ (BOOL)saveAll:(NSArray *)objects error:(NSError **)error;
//+ (void)saveAllInBackground:(NSArray *)objects;
//+ (void)saveAllInBackground:(NSArray *)objects block:(IQ_PFBooleanResultBlock)block;
//+ (void)saveAllInBackground:(NSArray *)objects target:(id)target selector:(SEL)selector;

//+ (BOOL)deleteAll:(NSArray *)objects;
//+ (BOOL)deleteAll:(NSArray *)objects error:(NSError **)error;
//+ (void)deleteAllInBackground:(NSArray *)objects;
//+ (void)deleteAllInBackground:(NSArray *)objects block:(IQ_PFBooleanResultBlock)block;
//+ (void)deleteAllInBackground:(NSArray *)objects target:(id)target selector:(SEL)selector;

//- (BOOL)isDataAvailable;
//- (void)refresh;
//- (void)refresh:(NSError **)error;
//- (void)refreshInBackgroundWithBlock:(IQ_PFObjectResultBlock)block;
//- (void)refreshInBackgroundWithTarget:(id)target selector:(SEL)selector;

//- (void)fetch:(NSError **)error;
//- (IQ_PFObject *)fetchIfNeeded;
//- (IQ_PFObject *)fetchIfNeeded:(NSError **)error;
//- (void)fetchInBackgroundWithBlock:(IQ_PFObjectResultBlock)block;
//- (void)fetchInBackgroundWithTarget:(id)target selector:(SEL)selector;
//- (void)fetchIfNeededInBackgroundWithBlock:(IQ_PFObjectResultBlock)block;
//- (void)fetchIfNeededInBackgroundWithTarget:(id)target selector:(SEL)selector;

//+ (void)fetchAll:(NSArray *)objects;
//+ (void)fetchAll:(NSArray *)objects error:(NSError **)error;
//+ (void)fetchAllIfNeeded:(NSArray *)objects;
//+ (void)fetchAllIfNeeded:(NSArray *)objects error:(NSError **)error;
//+ (void)fetchAllInBackground:(NSArray *)objects block:(IQ_PFArrayResultBlock)block;
//+ (void)fetchAllInBackground:(NSArray *)objects target:(id)target selector:(SEL)selector;
//+ (void)fetchAllIfNeededInBackground:(NSArray *)objects block:(IQ_PFArrayResultBlock)block;
//+ (void)fetchAllIfNeededInBackground:(NSArray *)objects target:(id)target selector:(SEL)selector;

//- (BOOL)delete;
//- (BOOL)delete:(NSError **)error;
//- (void)deleteInBackground;
//- (void)deleteInBackgroundWithBlock:(IQ_PFBooleanResultBlock)block;
//- (void)deleteInBackgroundWithTarget:(id)target selector:(SEL)selector;
//- (void)deleteEventually;

//- (BOOL)isDirty;
//- (BOOL)isDirtyForKey:(NSString *)key;

@end
