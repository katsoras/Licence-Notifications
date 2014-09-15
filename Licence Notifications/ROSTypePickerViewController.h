//
//  ROSTypePickerViewController.h
//  Licence Notifications
//
//  Created by rose on 14/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString * const DRIVER;
extern NSString * const VEHICLE;

@class ROSTypePickerViewController;

@protocol ROSTypePickerViewControllerDelegate<NSObject>
-(void) typePickerViewController:(ROSTypePickerViewController *)controller didSelectType:(NSString *)type;
@end

@interface ROSTypePickerViewController : UITableViewController
@property (nonatomic,weak) id<ROSTypePickerViewControllerDelegate> delegate;
@property (nonatomic,strong) NSString *type;
@end
