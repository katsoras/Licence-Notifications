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
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)save:(id)sender {
    NSString *licenceName = self.licenceNameTextField.text;
    BOOL type=[_type isEqualToString:VEHICLE];
    if (licenceName && licenceName.length) {
        //
        //set licence
        self.record.licenceName=licenceName;
        if(type)
            self.record.type=[NSNumber numberWithBool:YES];
        else
            self.record.type=[NSNumber numberWithBool:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your to-do needs a name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //
    //set Licence record
    if(self.record){
        [self.licenceNameTextField setText: self.record.licenceName];
        _type=VEHICLE;
        BOOL type=[[self.record type] boolValue];
        
        if(!type){
            _type=DRIVER;
        }
        //
        //set detail type
        [self.detailLabel setText: _type];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PickType"]) {
        ROSTypePickerViewController *typePickerViewController = segue.destinationViewController;
        typePickerViewController.delegate = self;
        typePickerViewController.type = _type;
    }
}

- (void)typePickerViewController:(ROSTypePickerViewController *)controller didSelectType:(NSString *)type
{
    _type = type;
    self.detailLabel.text = _type;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
