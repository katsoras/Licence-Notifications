//
//  ROSUtility.h
//  Licence Notifications
//
//  Created by rose on 8/10/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Notification.h"
@interface ROSUtility : NSObject
+(void) scheduleLocalNotifications:(NSMutableArray *)notifications;
+(NSString *) createUUID;
+(BOOL) checkForNotificationsAllUpdated:(NSSet *) notifications;
+(void) scheduleLocalNotification:(Notification *)notification;

+(NSMutableArray *)compareNotificationByExpireDate:(NSMutableArray *)notifications;
+(NSArray *) alertTypes;
+(NSString *) getAlertTypeLabelFromNumber:(NSNumber *)numberA;
+(void) cancelLocalNotication:(Notification *) notification;
+(void) cancelLocalNotifications:(NSSet *) notifications;
@end
