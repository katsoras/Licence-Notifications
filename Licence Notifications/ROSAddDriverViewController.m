//
//  ROSAddDriverViewController.m
//  Licence Notifications

//
//  Created by rose on 17/9/14.
//  Copyright (c) 2014 home. All rights reserved.
#import "ROSAddDriverViewController.h"
#import "ROSNotificationDateViewCell.h"
#import "ROSAddButtonLicenceViewCell.h"
#import "Driver.h"
#import "ROSTypePickerViewController.h"
@interface ROSAddDriverViewController ()
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;
//@property (nonatomic, strong) NSMutableArray *arrContactsData;
-(void)showAddressBook;
//
//holds driver notifications
@property (strong) NSMutableArray *driverNotifications;
//
//formatter for licence dates
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation ROSAddDriverViewController{
    NSString *firstName;
    NSString *lastName;
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
    self.driverNotifications=[NSMutableArray array];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd-MM-yyyy"];
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
    
    
    
    
    if (firstName && lastName && firstName.length && lastName.length) {
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Driver" inManagedObjectContext:self.managedObjectContext];
        
        Driver *driver = [[Driver alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        
        //
        //set driver values
        driver.lastName=lastName;
        driver.firstName=firstName;
        
        //
        //link with record
        [driver addNotifications:
         [NSSet setWithArray:self.driverNotifications]];
        
        /*[self.delegate setManagedObject:(NSManagedObject *)driver
                          forChangeType:NSFetchedResultsChangeInsert];*/
        [self dismissViewControllerAnimated:YES completion:nil];
        /*NSError *error = nil;
        if ([self.managedObjectContext save:&error]) {
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

-(void)showAddressBook{
    _addressBookController = [[ABPeoplePickerNavigationController alloc] init];
    [_addressBookController setPeoplePickerDelegate:self];
    [self presentViewController:_addressBookController animated:YES completion:nil];
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
    return 2+self.driverNotifications.count;
}

//
//ABPeoplePickerNavigationControllerDelegate methods
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
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
    //set driver first and last name
    firstName=[contactInfoDict objectForKey:@"firstName"];
    lastName=[contactInfoDict objectForKey:@"lastName"];
    
    [self.tableView reloadData];
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *addContactCellIdentifier = @"addContactCellIdentifier";
    static NSString *addAVLCellIdentifier=@"addAVLCellIdentifier";
    static NSString *notficationAVLIdentifier=@"notficationAVLIdentifier";
    
    if(indexPath.row==0){
        
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:addContactCellIdentifier];
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
        
        NSDate *defaultDate = item.expireDate;
        cell.notificateDateField.text = [self.dateFormatter stringFromDate:defaultDate];
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddLicenceEvent"]) {
        ROSAddVehicleLicenceEventViewController *typePickerViewController = segue.destinationViewController;
        typePickerViewController.managedObjectContext=self.managedObjectContext;
        typePickerViewController.delegate = self;
        typePickerViewController.type = [NSNumber numberWithInt:0];
    }
}

-(void) eventPickerViewController:(UITableViewController *)controller didSelectType:(Licence *) licence andDate:(NSDate *)date andNotification:(Notification *)notification{
    
    //
    //new notification
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notification" inManagedObjectContext:self.managedObjectContext];
    
    Notification *unassociatedObject = [[Notification alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    
    unassociatedObject.licence=licence;
    unassociatedObject.expireDate=date;
    
    [self.driverNotifications addObject:unassociatedObject];
    [self.tableView reloadData];
}

@end
