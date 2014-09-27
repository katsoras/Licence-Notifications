//
//  ROSAddVehicleLicenceViewController.m
//  Licence Notifications
//
//  Created by rose on 13/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import "ROSAddVehicleViewController.h"
#import "Vehicle.h"

#import "Notification.h"

#import "ROSAddVehicleLicenceEventViewController.h"

#import "ROSAddButtonLicenceViewCell.h"
#import "ROSRegistrationPlateViewCell.h"
#import "ROSModelViewCell.h"

#import "ROSTypePickerViewController.h"

@interface ROSAddVehicleViewController ()
//
//contains selected licences
@property (strong) NSMutableArray *vehicleLicences;

//
//contains expiredates per licence
@property (strong) NSMutableDictionary *licenceDates;

//
//formatter for licence dates
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

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
    self.vehicleLicences = [NSMutableArray array];
    self.licenceDates=[NSMutableDictionary dictionary];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    
    ROSModelViewCell * cell = (ROSModelViewCell *)[self.tableView
        cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString * model = cell.modelTextField.text;
    
    ROSRegistrationPlateViewCell * cell2 = (ROSRegistrationPlateViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString * registrationPlate = cell2.registrationPlateTextField.text;
    
    if (model && registrationPlate && model.length && registrationPlate.length) {
      
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Vehicle" inManagedObjectContext:self.managedObjectContext];
        
   
        Vehicle *vehicle = [[Vehicle alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        
        //
        //set vehicle values
        
        //
        //model
        vehicle.model=model;
        
        //
        //registration
        vehicle.registrationPlate=registrationPlate;
        
        //
        //notifications
        for (Licence * licence in self.vehicleLicences) {
            NSEntityDescription *entityNotification = [NSEntityDescription entityForName:@"Notification" inManagedObjectContext:self.managedObjectContext];
            
            Notification *notification = [[Notification alloc] initWithEntity:entityNotification insertIntoManagedObjectContext:self.managedObjectContext];
            //
            //
            notification.expireDate=
            [self.licenceDates objectForKey:[licence licenceName]];
            notification.licence=licence;
            
            //
            //link with record
            [vehicle addNotificationsObject:notification];
        }
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
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3+ self.vehicleLicences.count;
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
    }
    else if(indexPath.row==2){
        ROSAddButtonLicenceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addAVLCellIdentifier"];
        return cell;
    }else {
        UITableViewCell *cell = [tableView
            dequeueReusableCellWithIdentifier:@"notficationAVLIdentifier"];
        
        Licence *item = [self.vehicleLicences objectAtIndex:[indexPath row]-3];
         cell.textLabel.text=[item licenceName];
        
        NSDate *defaultDate = [self.licenceDates objectForKey:[item licenceName]];
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:defaultDate];
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

-(void) eventPickerViewController:(UITableViewController *)controller didSelectType:(Licence *) licence andDate:(NSDate *)date{
    //
    //contains selected licences;
    [self.vehicleLicences addObject:licence];
    //
    //map licence expire date with licence
    [self.licenceDates setObject:date forKey:licence.licenceName];
    [self.tableView reloadData];
}
@end