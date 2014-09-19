//
//  ROSEditDriverViewController.h
//  Licence Notifications
//
//  Created by rose on 18/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Driver;
@interface ROSEditDriverViewController : UITableViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Driver *record;


@end
