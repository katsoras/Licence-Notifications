//
//  ROSAlertPickerViewController.h
//  Licence Notifications
//
//  Created by rose on 17/10/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ROSAlertPickerViewController;
@protocol ROSAlertPickerViewControllerDelegate <NSObject>
- (void)alertPickerViewController:(ROSAlertPickerViewController *)controller didSelectAlert:(NSNumber *)alert;
@end



@interface ROSAlertPickerViewController : UITableViewController
@property (nonatomic,strong) NSString *alertType;
@property (nonatomic, weak) id <ROSAlertPickerViewControllerDelegate> delegate;
@end
