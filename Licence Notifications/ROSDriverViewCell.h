//
//  ROSDriverViewCell.h
//  Licence Notifications
//
//  Created by rose on 30/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ROSDriverViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *lastNameLabelField;
@property (nonatomic, weak) IBOutlet UILabel *firstNameLabelField;

@property (nonatomic,weak) IBOutlet UIImageView * statusImage;

@end
