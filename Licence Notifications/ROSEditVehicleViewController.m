//
//  ROSEditVehicleViewController.m
//  Licence Notifications
//
//  Created by rose on 14/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//
#import "ROSAddButtonLicenceViewCell.h"
#import "ROSRegistrationPlateViewCell.h"
#import "ROSModelViewCell.h"
#import "ROSEditVehicleViewController.h"
#import "Licence.h"
#import "Notification.h"
#import "ROSPickLicenceViewController.h"
@interface ROSEditVehicleViewController ()
//
//contains selected licences
@property (strong) NSMutableArray *vehicleNotifications;
//
//formatter for licence dates
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

//
//holds selected index path
@property (strong, nonatomic) NSIndexPath *selection;
@end

@implementation ROSEditVehicleViewController

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
    if(self.record){
        
        self.vehicleNotifications = [NSMutableArray arrayWithArray:[self.record.notifications allObjects]];
    }
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
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
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3+ self.vehicleNotifications.count;
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
        
        Notification *item = [self.vehicleNotifications objectAtIndex:[indexPath row]-3];
        
        cell.textLabel.text=item.licence.licenceName;
        
        NSDate *defaultDate = item.expireDate;
        
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:defaultDate];
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //
        //delete notfication from data source
        [self.vehicleNotifications
         removeObjectAtIndex:[indexPath row]-3];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
//
//notify when the detailed disclosure button is tapped
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self setSelection:indexPath];
    //
    // Perform Segue
    [self performSegueWithIdentifier:@"AddLicenceEvent" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"AddLicenceEvent"]) {
        
        //
        // Obtain Reference to View Controller
        ROSAddVehicleLicenceEventViewController *vc = (ROSAddVehicleLicenceEventViewController *)[segue destinationViewController];
        
        //
        // Configure View Controller
        [vc setManagedObjectContext:self.managedObjectContext];
        if (self.selection) {
            
            //
            // Fetch Record
            Notification *record = [self.vehicleNotifications objectAtIndex:self.selection.row-3];
            if (record) {
                [vc setNotification:record];
            }
            vc.delegate = self;
            //
            // Reset Selection
            [self setSelection:nil];
        }
    }
}
-(void) eventPickerViewController:(UITableViewController *)controller didSelectType:(Licence *) licence andDate:(NSDate *)date{
    
}
@end