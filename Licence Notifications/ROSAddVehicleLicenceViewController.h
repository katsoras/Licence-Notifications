//
//  ROSAddVehicleLicenceViewController.h
//  Licence Notifications
//
//  Created by rose on 13/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ROSAddLicenceEventViewController.h"

@interface ROSAddVehicleLicenceViewController : UITableViewController<ROSEventPickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *modelTextField;
@property (weak, nonatomic) IBOutlet UITextField *registrationPlateTextField;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
