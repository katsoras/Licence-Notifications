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
+(void) createLocalNotifications:(NSMutableArray *)notifications;

+(NSString *) createUUID;
+(BOOL) checkForNotificationsAllUpdated:(NSSet *) notifications;
+(void) createLocalNotification:(Notification *)notification;
+(NSMutableArray *)compareNotificationByExpireDate:(NSMutableArray *)notifications;
+(NSArray *) alertTypes;
+(NSString *) getAlertTypeLabelFromNumber:(NSNumber *)numberA;
+(void) cancelLocalNotication:(Notification *) notification;
@end
