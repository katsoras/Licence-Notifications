//
//  ROSEditDriverViewController.h
//  Licence Notifications
//
//  Created by rose on 18/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ROSAddVehicleLicenceEventViewController.h"
#import "Driver.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface ROSEditDriverViewController : UITableViewController
<ROSLicencePickerViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak,nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) Driver *record;


@end
