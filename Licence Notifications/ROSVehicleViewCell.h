//
//  ROSVehicleViewCell.h
//  Licence Notifications
//
//  Created by rose on 28/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ROSVehicleViewCell : UITableViewCell
 @property (nonatomic, weak) IBOutlet UILabel *modelLabelField;
 @property (nonatomic, weak) IBOutlet UILabel *registerPlateLabelField;
@property (nonatomic,weak) IBOutlet UIImageView * statusImage;

@end
