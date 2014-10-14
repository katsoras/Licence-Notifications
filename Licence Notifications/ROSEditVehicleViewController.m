//
//  ROSEditVehicleViewController.m
//  Licence Notifications
//
//  Created by rose on 14/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//
#import "ROSAddButtonLicenceViewCell.h"
#import "ROSRegistrationPlateViewCell.h"
#import "ROSNotificationDateViewCell.h"
#import "ROSModelViewCell.h"
#import "ROSEditVehicleViewController.h"
#import "Licence.h"
#import "Notification.h"
#import "ROSUtility.h"
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

@implementation ROSEditVehicleViewController{
    NSMutableArray *toDeleteNotifications;
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
    if(self.record){
        self.vehicleNotifications =
        [ROSUtility compareNotificationByExpireDate:
        [NSMutableArray arrayWithArray:[self.record.notifications allObjects]]];
    }
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd-MM-yyyy"];
    toDeleteNotifications=[[NSMutableArray alloc]init];
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
    ROSModelViewCell * cell = (ROSModelViewCell *)[self.tableView
                                                   cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString * model = cell.modelTextField.text;
    ROSRegistrationPlateViewCell * cell2 = (ROSRegistrationPlateViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NSString * registrationPlate = cell2.registrationPlateTextField.text;
    if (model && registrationPlate &&
        model.length && registrationPlate.length) {
        //
        //set vehicle values
        
        //
        //model
        self.record.model=model;
        
        //
        //registration
        self.record.registrationPlate=registrationPlate;
        
        //
        //delete removed notification
        for (Notification *managedObject in toDeleteNotifications) {
            [self.managedObjectContext deleteObject:managedObject];
        }
        
        //
        //link with record
        [self.record addNotifications:
        [NSSet setWithArray:self.vehicleNotifications]];
        
      
        
        ///NSError *error = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
        
        /*if ([self.managedObjectContext save:&error]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        else
        {
            if (error) {
                NSLog(@"Unable to save record.");
                NSLog(@"%@, %@", error, error.localizedDescription);
            }
            
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your to-do could not be saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }*/
    }
    else {
        
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
       
        cell.modelTextField.text=self.record.model;
        return cell;
    }
    else if(indexPath.row==1){
        ROSRegistrationPlateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:plateAVLIdentifier];
        cell.registrationPlateTextField.text=self.record.registrationPlate;
        return cell;
    }
    else if(indexPath.row==2){
        ROSAddButtonLicenceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addAVLCellIdentifier];
        return cell;
    }else {
        ROSNotificationDateViewCell *cell = [tableView    dequeueReusableCellWithIdentifier:notficationAVLIdentifier];
        
        Notification *item = [self.vehicleNotifications objectAtIndex:[indexPath row]-3];
       
        NSLog(@"Cell For Notification:%@ with expire date:%@",item.licence.licenceName,item.expireDate);
        
        cell.licenceDateLabelField.text=item.licence.licenceName;
        cell.notificateDateField.text = [self.dateFormatter stringFromDate:item.expireDate];
       
        NSComparisonResult result = [[NSDate date] compare:item.expireDate];
        
        if (result==NSOrderedDescending) {
            cell.licenceDateLabelField.textColor = [UIColor redColor];
        }
        
        else {
             cell.licenceDateLabelField.textColor = [UIColor blackColor];
        }
        
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row>2)
        return YES;
    else
        return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //
        //delete notfication from data source
        Notification *toMoveNotification=[self.vehicleNotifications objectAtIndex:[indexPath row]-3];
        //
        //add to array contains the objects to be deleted.
        [toDeleteNotifications addObject:toMoveNotification];
        NSLog(@"%@",toMoveNotification.expireDate);
        
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
        vc.delegate = self;
        //
        //
        vc.type =[NSNumber numberWithInt:1];
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
            //
            // Reset Selection
            [self setSelection:nil];
        }
    }
}
-(void) eventPickerViewController:(UITableViewController *)controller didSelectType:(Licence *) licence andDate:(NSDate *)date andNotification:(Notification *)notification{
    
    //
    //EDIT MODE value, populate notification pointer
    if(notification){
        notification.licence=licence;
        notification.expireDate=date;
    }
    
    //ADD MODE
    else{
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notification" inManagedObjectContext:self.managedObjectContext];
        
        Notification *unassociatedObject = [[Notification alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        
        unassociatedObject.licence=licence;
        unassociatedObject.expireDate=date;
        NSUInteger newIndex = [self.vehicleNotifications
                               indexOfObject:unassociatedObject
                               inSortedRange:(NSRange){0, [self.vehicleNotifications count]}
                               options:NSBinarySearchingInsertionIndex
                               usingComparator:^(Notification *obj1, Notification * obj2){
                                   return [obj2.expireDate compare:obj1.expireDate];
                               }];
        [self.vehicleNotifications insertObject:unassociatedObject
                                       atIndex:newIndex];
    }
    [self.tableView reloadData];
}
@end