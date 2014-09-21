//
//  ROSAddLicenceEventViewController.h
//  Licence Notifications
//
//  Created by rose on 20/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ROSPickLicenceViewController.h"

@class ROSAddVehicleLicenceEventViewController;
@protocol ROSEventPickerViewControllerDelegate<NSObject>
-(void) eventPickerViewController:(ROSAddVehicleLicenceEventViewController *)controller didSelectType:(NSString *)type;
@end


@interface ROSAddVehicleLicenceEventViewController : UITableViewController<ROSLicencePickerViewControllerDelegate>

@property (nonatomic,weak) id<ROSEventPickerViewControllerDelegate> delegate;

@property (nonatomic,strong) NSString *type;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UILabel *licenceNameLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *expireDateLabel;

@end