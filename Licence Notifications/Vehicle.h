//
//  Vehicle.h
//  Licence Notifications
//
//  Created by rose on 8/10/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Notification;

@interface Vehicle : NSManagedObject

@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * registrationPlate;
@property (nonatomic, retain) NSSet *notifications;
@end

@interface Vehicle (CoreDataGeneratedAccessors)

- (void)addNotificationsObject:(Notification *)value;
- (void)removeNotificationsObject:(Notification *)value;
- (void)addNotifications:(NSSet *)values;
- (void)removeNotifications:(NSSet *)values;

@end
