//
//  ROSAddLicenceViewController.h
//  Licence Notifications
//
//  Created by rose on 14/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ROSTypePickerViewController.h"

@interface ROSAddLicenceViewController : UITableViewController<ROSTypePickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *licenceNameTextField;
@property (weak,nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
