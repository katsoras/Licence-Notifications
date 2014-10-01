//
//  ROSAddLicenceEventViewController.h
//  Licence Notifications
//
//  Created by rose on 20/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notification.h"
#import "Licence.h"

@class ROSAddVehicleLicenceEventViewController;
@protocol ROSLicencePickerViewControllerDelegate<NSObject>
-(void) eventPickerViewController:(UITableViewController *)controller didSelectType:(Licence *) licence andDate:(NSDate *)date andNotification:(Notification *)notification;
@end


@interface ROSAddVehicleLicenceEventViewController : UITableViewController<ROSLicencePickerViewControllerDelegate>

@property (nonatomic,weak) id<ROSLicencePickerViewControllerDelegate> delegate;

@property (nonatomic,strong) NSNumber *type;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UILabel *licenceNameLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *expireDateLabel;


@property (strong, nonatomic) Notification *notification;

@end