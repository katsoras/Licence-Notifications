//
//  ROSEditDriverViewController.m
//  Licence Notifications
//
//  Created by rose on 18/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import "ROSAddButtonLicenceViewCell.h"
#import "ROSNotificationDateViewCell.h"
#import "Licence.h"
#import "Notification.h"
#import "ROSPickLicenceViewController.h"
#import "ROSEditDriverViewController.h"
#import "ROSUtility.h"
@interface ROSEditDriverViewController ()
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;
//@property (nonatomic, strong) NSMutableArray *arrContactsData;
-(void)showAddressBook;
//
//contains selected licences
@property (strong) NSMutableArray *driverNotifications;

//
//formatter for licence dates
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

//
//holds selected index path
@property (strong, nonatomic) NSIndexPath *selection;

@end

@implementation ROSEditDriverViewController {
    NSMutableArray *toDeleteNotifications;
    NSString *firstName;
    NSString *lastName;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    //init exists driver
    if(self.record){
        self.driverNotifications =[ROSUtility compareNotificationByExpireDate:
                                [NSMutableArray arrayWithArray:[self.record.notifications allObjects]]];
        firstName=self.record.firstName;
        lastName=self.record.lastName;
    }
    //
    //New driver
    else{
        self.driverNotifications=[NSMutableArray array];
    }
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd-MM-yyyy"];
    toDeleteNotifications=[[NSMutableArray alloc]init];
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)save:(id)sender {
    
    if (firstName && lastName &&
        firstName.length && lastName.length) {
        //
        //set driver values
        
        //
        //edit driver
        if(self.record){
            self.record.firstName=firstName;
            self.record.lastName=lastName;
        
            //
            //delete removed notification
            for (Notification *managedObject in toDeleteNotifications) {
                [ROSUtility cancelLocalNotication:managedObject];
                [self.managedObjectContext deleteObject:managedObject];
            }
            //
            //link with record
            [self.record addNotifications:[NSSet setWithArray:self.driverNotifications]];
            
            //
            //recreate local notifications for edited notifications
            for (Notification *managedObject in self.driverNotifications) {
                [ROSUtility cancelLocalNotication:managedObject];
                [ROSUtility createLocalNotification:managedObject];
            }
        }
        //
        //Add driver
        else
        {
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Driver" inManagedObjectContext:self.managedObjectContext];
            
            Driver *driver = [[Driver alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
            
            //
            //set driver values
            driver.lastName=lastName;
            driver.firstName=firstName;
            
            //
            //link with record
            [driver addNotifications:[NSSet setWithArray:self.driverNotifications]];
        }
        //
        //register notifications
        [ROSUtility createLocalNotifications:self.driverNotifications];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your to-do needs a name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//
//ABPeoplePickerNavigationControllerDelegate methods

-(void)showAddressBook{
    _addressBookController = [[ABPeoplePickerNavigationController alloc] init];
    [_addressBookController setPeoplePickerDelegate:self];
    [self presentViewController:_addressBookController animated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person;
{
    NSMutableDictionary *contactInfoDict = [[NSMutableDictionary alloc]
                                            initWithObjects:@[@"", @"", @""]
                                            forKeys:@[@"firstName", @"lastName", @"mobileNumber"]];
    CFTypeRef generalCFObject;
    generalCFObject = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"firstName"];
        CFRelease(generalCFObject);
    }
    generalCFObject = ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (generalCFObject) {
        
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"lastName"];
        CFRelease(generalCFObject);
        
    }
    //
    //set driver name and last name
    firstName=[contactInfoDict objectForKey:@"firstName"];
    lastName=[contactInfoDict objectForKey:@"lastName"];
    
    [self.tableView reloadData];
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 && indexPath.row == 0)
    {
        [self showAddressBook];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2+ self.driverNotifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *addContactCellIdentifier = @"addContactCellIdentifier";
    static NSString *addAVLCellIdentifier=@"addAVLCellIdentifier";
    static NSString *notficationAVLIdentifier=@"notficationAVLIdentifier";
    
    if(indexPath.row==0){
        UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:addContactCellIdentifier];
        
        if(firstName && lastName){
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@", firstName, lastName];
        }
        return cell;
    }
    else if(indexPath.row==1){
        ROSAddButtonLicenceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addAVLCellIdentifier];
        return cell;
    }
    else
    {
        ROSNotificationDateViewCell *cell = [tableView
        dequeueReusableCellWithIdentifier:notficationAVLIdentifier];
        
        Notification *item = [self.driverNotifications objectAtIndex:[indexPath row]-2];
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
    if(indexPath.row==1){
        return 44;
    }
    else {
        return 62;
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row>1)
        return YES;
    else
        return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        //
        //delete notfication from data source
        Notification *toMoveNotification=[self.driverNotifications objectAtIndex:[indexPath row]-2];
        if(self.record){
            //
            //add to array contains the objects to be deleted.
            [toDeleteNotifications addObject:toMoveNotification];
        }
        [self.driverNotifications removeObjectAtIndex:[indexPath row]-2];
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
        vc.type =[NSNumber numberWithInt:0];
        //
        // Configure View Controller
        [vc setManagedObjectContext:self.managedObjectContext];
        if (self.selection) {
            //
            // Fetch Record
            Notification *record = [self.driverNotifications objectAtIndex:self.selection.row-2];
            if (record) {
                [vc setNotification:record];
            }
            //
            // Reset Selection
            [self setSelection:nil];
        }
    }
}
-(void) eventPickerViewController:(UITableViewController *)controller didSelectType:(Licence *) licence andDate:(NSDate *)date andNotify:(NSNumber *) notify andNotification:(Notification *)notification{
    //
    //Edit Notification
    if(notification){
        notification.licence=licence;
        notification.expireDate=date;
        notification.notify=notify;
    }
    //Add Notification
    else{
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notification" inManagedObjectContext:self.managedObjectContext];
        
        Notification *unassociatedObject = [[Notification alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        
        unassociatedObject.licence=licence;
        unassociatedObject.expireDate=date;
       //[self.driverNotifications addObject:unassociatedObject];
        NSUInteger newIndex = [self.driverNotifications indexOfObject:unassociatedObject
                               
            inSortedRange:(NSRange){0, [self.driverNotifications count]}
                options:NSBinarySearchingInsertionIndex
                usingComparator:^(Notification *obj1, Notification * obj2)
                {
                    return [obj2.expireDate compare:obj1.expireDate];
                }];
        [self.driverNotifications insertObject:unassociatedObject atIndex:newIndex];
        
    }
    [self.tableView reloadData];
}

@end
