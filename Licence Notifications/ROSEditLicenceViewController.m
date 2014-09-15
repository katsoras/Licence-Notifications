//
//  ROSEditLicenceViewController.m
//  Licence Notifications
//
//  Created by rose on 14/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import "ROSEditLicenceViewController.h"
#import "Licence.h"
#import "ROSTypePickerViewController.h"
@interface ROSEditLicenceViewController ()

@end

@implementation ROSEditLicenceViewController{
    NSString *_type;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //set Licence record
    if(self.record){
        [self.licenceNameTextField setText: self.record.licenceName];
        _type=VEHICLE;
        
        BOOL type=[[self.record type] boolValue];
        if(!type){
            _type=DRIVER;
        }
        [self.TypeLabel setText: _type];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
