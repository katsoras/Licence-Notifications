//
//  ROSUtility.h
//  Licence Notifications
//
//  Created by rose on 8/10/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ROSUtility : NSObject
+(void) createLocalNotification:(NSMutableArray *)notifications;
+(NSString *) createUUID;
@end
