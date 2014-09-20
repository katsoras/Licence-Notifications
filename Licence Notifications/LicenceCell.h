//
//  LicenceCell.h
//  Licence Notifications
//
//  Created by rose on 20/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LicenceCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UISwitch *detailsSwitch;
@end
