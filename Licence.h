//
//  Licence.h
//  Licence Notifications
//
//  Created by rose on 27/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Notification;

@interface Licence : NSManagedObject

@property (nonatomic, retain) NSString * licenceName;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSSet *notifications;
@end

@interface Licence (CoreDataGeneratedAccessors)

- (void)addNotificationsObject:(Notification *)value;
- (void)removeNotificationsObject:(Notification *)value;
- (void)addNotifications:(NSSet *)values;
- (void)removeNotifications:(NSSet *)values;

@end
