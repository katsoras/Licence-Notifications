//
//  ROSUtility.m
//  Licence Notifications
//
//  Created by rose on 8/10/14.
//  Copyright (c) 2014 home. All rights reserved.
//
#import "Notification.h"
#import "Licence.h"
#import "Driver.h"
#import "Vehicle.h"
#import "ROSUtility.h"

@implementation ROSUtility

+(NSMutableArray *)compareNotificationByExpireDate:(NSMutableArray *)notifications{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"expireDate"
                                            ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [notifications sortedArrayUsingDescriptors:sortDescriptors];
    return [ROSUtility createMutableArray:sortedArray];
}
+ (NSMutableArray *)createMutableArray:(NSArray *)array
{
    return [NSMutableArray arrayWithArray:array];
}
+(BOOL)checkForNotificationsAllUpdated:(NSSet *) notifications{
    
    for (Notification *notification in notifications) {
        NSComparisonResult result = [[NSDate date] compare:notification.expireDate];
        if (result==NSOrderedDescending){
            return YES;
        }
    }
    return NO;
}
+(void) createLocalNotification:(NSMutableArray *) notifications{
    
    for(Notification *notification in notifications){
        //
        // Schedule the notification
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = notification.expireDate;
        NSString *bodyHead;
        
        if(notification.driver){
            bodyHead=notification.driver.lastName;
        }else {
            bodyHead=notification.vehicle.model;
        }
        localNotification.alertBody =
        [NSString stringWithFormat:@"%@ %@",bodyHead,
         notification.licence.licenceName];
        
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        
        [localNotification setUserInfo:[NSDictionary dictionaryWithObject:notification.notificationRefId forKey:@"uid"]];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        NSLog(@"Notification with id %@ created",notification.notificationRefId);
    
    }
}
+(NSString *) createUUID {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int len = 10;
    
    NSMutableString *randomListName = [NSMutableString stringWithCapacity:len];
    for (int i=0; i<len; i++) {
        [randomListName appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomListName;
}
@end
