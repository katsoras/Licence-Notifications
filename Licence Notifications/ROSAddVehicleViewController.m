//
//  ROSAddVehicleLicenceViewController.m
//  Licence Notifications
//
//  Created by rose on 13/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import "ROSAddVehicleViewController.h"
#import "Vehicle.h"
#import "ROSAddVehicleLicenceEventViewController.h"

#import "ROSAddButtonLicenceViewCell.h"
#import "ROSRegistrationPlateViewCell.h"
#import "ROSModelViewCell.h"

#import "ROSTypePickerViewController.h"
@interface ROSAddVehicleViewController ()
    @property (strong) NSMutableArray *vehicleLicences;
@end


@implementation ROSAddVehicleViewController

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
   /* NSString *model = self.modelTextField.text;
    NSString *registrationPlate=self.registrationPlateTextField.text;
    
    if (model && registrationPlate && model.length && registrationPlate.length) {
      
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Vehicle" inManagedObjectContext:self.managedObjectContext];
        
   
        Vehicle *record = [[Vehicle alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        
       
        
        record.model=model;
        record.registrationPlate=registrationPlate;
        
        
        NSError *error = nil;
        if ([self.managedObjectContext save:&error]) {
           
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            
            if (error) {
                NSLog(@"Unable to save record.");
                NSLog(@"%@, %@", error, error.localizedDescription);
            }
            
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your to-do could not be saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    } else {
        
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your to-do needs a name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }*/
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3+self.vehicleLicences.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        ROSModelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"modelAVLIdentifier"];
        return cell;
    }
    else if(indexPath.row==1){
        ROSRegistrationPlateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plateAVLIdentifier"];
        return cell;
    }else if(indexPath.row==2){
        ROSAddButtonLicenceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addAVLCellIdentifier"];
        return cell;
    }else {
        
        UITableViewCell *cell = [tableView
            dequeueReusableCellWithIdentifier:@"notficationAVLIdentifier"];
        return cell;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddLicenceEvent"]) {
        ROSAddVehicleLicenceEventViewController *typePickerViewController = segue.destinationViewController;
        typePickerViewController.managedObjectContext=self.managedObjectContext;
        
        typePickerViewController.delegate = self;
        typePickerViewController.type =VEHICLE;
        
    }
}

-(void) eventPickerViewController:(id *)controller didSelectType:(Licence *) licence{
    
}
@end
