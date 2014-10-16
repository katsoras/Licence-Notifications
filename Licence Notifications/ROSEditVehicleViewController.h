//
//  ROSEditVehicleViewController.h
//  Licence Notifications
//
//  Created by rose on 14/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ROSAddVehicleLicenceEventViewController.h"
#import "Vehicle.h"

@interface ROSEditVehicleViewController : UITableViewController<ROSLicencePickerViewControllerDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Vehicle *record;
@end