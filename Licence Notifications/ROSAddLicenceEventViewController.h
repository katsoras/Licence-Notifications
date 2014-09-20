//
//  ROSAddLicenceEventViewController.h
//  Licence Notifications
//
//  Created by rose on 20/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ROSAddLicenceEventViewController;
@protocol ROSEventPickerViewControllerDelegate<NSObject>
-(void) eventPickerViewController:(ROSAddLicenceEventViewController *)controller didSelectType:(NSString *)type;
@end


@interface ROSAddLicenceEventViewController : UITableViewController
@property (nonatomic,weak) id<ROSEventPickerViewControllerDelegate> delegate;
@property (nonatomic,strong) NSString *type;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end