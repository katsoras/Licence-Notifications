//
//  ROSAddVehicleLicenceViewController.h
//  Licence Notifications
//
//  Created by rose on 13/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ROSAddVehicleLicenceEventViewController.h"

@interface ROSAddVehicleViewController : UITableViewController<ROSLicencePickerViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
