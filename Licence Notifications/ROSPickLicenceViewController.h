//
//  ROSPickLicenceViewController.h
//  Licence Notifications
//
//  Created by rose on 21/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Licence.h"
#import "ROSAddVehicleLicenceEventViewController.h"

//@class ROSPickLicenceViewController;
//@protocol ROSLicencePickerViewControllerDelegate<NSObject>
//-(void) typePickerViewController:(ROSPickLicenceViewController *)controller /didSelectType:(Licence *)type;
//@end


@interface ROSPickLicenceViewController : UITableViewController
@property (nonatomic,weak) id<ROSLicencePickerViewControllerDelegate> delegate;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSNumber *type;
@end
