//
//  ROSNotificationViewCell.h
//  Licence Notifications
//
//  Created by rose on 9/10/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ROSNotificationViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *notificateExpireDate;
@property (nonatomic, weak) IBOutlet UILabel *notificateLicenceName;
@end
