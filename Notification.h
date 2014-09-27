//
//  Notification.h
//  Licence Notifications
//
//  Created by rose on 27/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Driver, Licence, Vehicle;

@interface Notification : NSManagedObject

@property (nonatomic, retain) NSDate * expireDate;
@property (nonatomic, retain) Licence *licence;
@property (nonatomic, retain) Driver *driver;
@property (nonatomic, retain) Vehicle *vehicle;

@end
