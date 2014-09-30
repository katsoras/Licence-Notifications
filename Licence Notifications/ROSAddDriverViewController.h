//
//  ROSAddDriverViewController.h
//  Licence Notifications
//
//  Created by rose on 17/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "ROSAddVehicleLicenceEventViewController.h"
@interface ROSAddDriverViewController : UITableViewController<ABPeoplePickerNavigationControllerDelegate,ROSLicencePickerViewControllerDelegate>

@property (weak,nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
