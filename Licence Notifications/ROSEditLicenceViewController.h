//
//  ROSEditLicenceViewController.h
//  Licence Notifications
//
//  Created by rose on 14/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import "ROSTypePickerViewController.h"

#import <UIKit/UIKit.h>
@class Licence;

@interface ROSEditLicenceViewController : UITableViewController
<ROSTypePickerViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Licence *record;

@property (weak, nonatomic) IBOutlet UITextField *licenceNameTextField;
@property (weak,nonatomic) IBOutlet UILabel *detailLabel;
@end
