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
+(void) cancelLocalNotication:(Notification *) notification{
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"uid"]];
        if ([uid isEqualToString:notification.notificationRefId])
        {
            //Cancelling local notification
            [app cancelLocalNotification:oneEvent];
            break;
        }
        
    }
}
+(void) createLocalNotifications:(NSMutableArray *) notifications{
    
    for(Notification *notification in notifications){
        //
        // Schedule the notification
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        
        
        localNotification.fireDate=notification.expireDate;
        if(notification.expireDate){
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            [dateComponents setDay:- [notification.notify integerValue]];
            
            NSDate *sevenDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:notification.expireDate options:0];
            localNotification.fireDate = sevenDaysAgo;
        }
        NSString *bodyHead;
        if(notification.driver){
            bodyHead=notification.driver.lastName;
        }else {
            bodyHead=notification.vehicle.model;
        }
        localNotification.soundName=UILocalNotificationDefaultSoundName;
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
+(NSString *) getAlertTypeLabelFromNumber:(NSNumber *)numberA{
    int num=[numberA intValue];
    NSString *alertType=nil;
    
    switch (num) {
        case 0:{
            alertType=[ROSUtility alertTypes][0];
            break;
        }
        case 1:{
            alertType=[ROSUtility alertTypes][1];
            break;
        }
        case 2:{
            alertType=[ROSUtility alertTypes][2];
            break;
        }case 3:{
            alertType=[ROSUtility alertTypes][3];
            break;
        }case 4:{
            alertType=[ROSUtility alertTypes][4];
            break;
        }
        default:{
            alertType=[ROSUtility alertTypes][5];
            break;
        }
    }
    return alertType;
}
+(NSArray *) alertTypes{
    return @[@"None", @"1 week before", @"2 weeks before", @"3 weeks before", @"4 weeks before"];
}
@end
