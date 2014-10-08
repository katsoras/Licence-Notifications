//
//  ROSUtility.m
//  Licence Notifications
//
//  Created by rose on 8/10/14.
//  Copyright (c) 2014 home. All rights reserved.
//
#import "Notification.h"
#import "ROSUtility.h"

@implementation ROSUtility

+(void) createLocalNotification:(NSMutableArray *) notifications{
    
    for(Notification *notification in notifications){
        //
        // Schedule the notification
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = notification.expireDate;
        localNotification.alertBody = @"";
        localNotification.alertAction = @"Show me the item";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        [localNotification setUserInfo:[NSDictionary dictionaryWithObject:notification.notificationRefId forKey:@"uid"]];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
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
