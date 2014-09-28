//
//  ROSAddLicenceViewController.m
//  Licence Notifications
//
//  Created by rose on 14/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import "ROSAddLicenceViewController.h"
#import "Licence.h"
#import "ROSTypePickerViewController.h"
@interface ROSAddLicenceViewController ()

@end

@implementation ROSAddLicenceViewController{
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
    self.detailLabel.text = _type;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        NSLog(@"init PlayerDetailsViewController");
        _type = VEHICLE;
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)save:(id)sender {
    // Helpers
    NSString *licenceName = self.licenceNameTextField.text;
    BOOL type=[_type isEqualToString:VEHICLE];
    if (licenceName && licenceName.length) {
        //
        // Create Entity
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Licence" inManagedObjectContext:self.managedObjectContext];
        
        // Initialize Record
        Licence *record = [[Licence alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Populate Record
        record.licenceName=licenceName;
        if(type)
            record.type=[NSNumber numberWithBool:YES];
        else
            record.type=[NSNumber numberWithBool:NO];
       
        //
        // Save Record
        NSError *error = nil;
        if ([self.managedObjectContext save:&error]) {
            // Dismiss View Controller
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            if (error) {
                NSLog(@"Unable to save record.");
                NSLog(@"%@, %@", error, error.localizedDescription);
            }
            // Show Alert View
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your to-do could not be saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    } else {
        // Show Alert View
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your to-do needs a name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
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
