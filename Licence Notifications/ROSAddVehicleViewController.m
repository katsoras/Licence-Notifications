//
//  ROSAddVehicleLicenceViewController.m
//  Licence Notifications
//
//  Created by rose on 13/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import "ROSAddVehicleViewController.h"
#import "Vehicle.h"
#import "ROSNotificationDateViewCell.h"
//#import "Notification.h"
#import "ROSUtility.h"
#import "ROSAddVehicleLicenceEventViewController.h"

#import "ROSAddButtonLicenceViewCell.h"
#import "ROSRegistrationPlateViewCell.h"
#import "ROSModelViewCell.h"

@interface ROSAddVehicleViewController ()


@property (strong) NSMutableArray *vehicleNotifications;

//
//contains selected licences
//@property (strong) NSMutableArray *vehicleLicences;

//
//contains expiredates per licence
//@property (strong) NSMutableDictionary *licenceDates;

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
    
    self.vehicleNotifications=[NSMutableArray array];
    
    //self.vehicleLicences = [NSMutableArray array];
    //self.licenceDates=[NSMutableDictionary dictionary];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd-MM-yyyy"];
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
        //link with record
        [vehicle addNotifications:
        [NSSet setWithArray:self.vehicleNotifications]];
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        /*NSError *error = nil;
        if ([self.managedObjectContext save:&error]) {
            
            [ROSUtility createLocalNotification:self.vehicleNotifications];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            if (error) {
                NSLog(@"Unable to save record.");
                NSLog(@"%@, %@", error, error.localizedDescription);
            }
            
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your to-do could not be saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }*/
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
    return 3+ self.vehicleNotifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *modelAVLIdentifier=@"modelAVLIdentifier";
    static NSString *plateAVLIdentifier=@"plateAVLIdentifier";
    static NSString *addAVLCellIdentifier=@"addAVLCellIdentifier";
    static NSString *notficationAVLIdentifier=@"notficationAVLIdentifier";
    
    if(indexPath.row==0){
        ROSModelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:modelAVLIdentifier];
        return cell;
    }
    else if(indexPath.row==1){
        ROSRegistrationPlateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:plateAVLIdentifier];
        return cell;
    }
    else if(indexPath.row==2){
        ROSAddButtonLicenceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addAVLCellIdentifier];
        return cell;
    }else {
        
        ROSNotificationDateViewCell *cell = [tableView
dequeueReusableCellWithIdentifier:notficationAVLIdentifier];
        
        Notification *item = [self.vehicleNotifications objectAtIndex:[indexPath row]-3];
        cell.licenceDateLabelField.text=item.licence.licenceName;
        NSDate *defaultDate = item.expireDate;
        
        cell.notificateDateField.text = [self.dateFormatter stringFromDate:defaultDate];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row>2){
        return 62;
    }
    else {
        return 44;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddLicenceEvent"]) {
        
        ROSAddVehicleLicenceEventViewController *typePickerViewController = segue.destinationViewController;
        typePickerViewController.managedObjectContext=self.managedObjectContext;
        
        typePickerViewController.delegate = self;
        typePickerViewController.type =[NSNumber numberWithInt:1];
    }
}
-(void) eventPickerViewController:(UITableViewController *)controller didSelectType:(Licence *) licence andDate:(NSDate *)date andNotification:(Notification *)notification{
    
    //
    //new notification
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notification" inManagedObjectContext:self.managedObjectContext];
    
    Notification *unassociatedObject = [[Notification alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    
    unassociatedObject.licence=licence;
    unassociatedObject.expireDate=date;
    
    unassociatedObject.notificationRefId=[ROSUtility createUUID];
    NSUInteger newIndex = [self.vehicleNotifications
                           indexOfObject:unassociatedObject
                           inSortedRange:(NSRange){0, [self.vehicleNotifications count]}
                           options:NSBinarySearchingInsertionIndex
                           usingComparator:^(Notification *obj1, Notification * obj2){
                               return [obj2.expireDate compare:obj1.expireDate];
                           }];
    [self.vehicleNotifications insertObject:unassociatedObject
                                   atIndex:newIndex];
    [self.tableView reloadData];
}
@end