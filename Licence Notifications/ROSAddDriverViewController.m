//
//  ROSAddDriverViewController.m
//  Licence Notifications
//
//  Created by rose on 17/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import "ROSAddDriverViewController.h"
#import "Driver.h"

@interface ROSAddDriverViewController ()
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;
@property (nonatomic, strong) NSMutableArray *arrContactsData;
-(void)showAddressBook;
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
    if (firstName && lastName) {
        //
        // Create Entity
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Driver" inManagedObjectContext:self.managedObjectContext];
        
        // Initialize Record
        Driver *record = [[Driver alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Populate Record
        record.lastName=lastName;
        record.firstName=firstName;
        
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
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
    
    firstName=[contactInfoDict objectForKey:@"firstName"];
    lastName=[contactInfoDict objectForKey:@"lastName"];
    
    NSString *concatFullName=[[firstName stringByAppendingString:@" "] stringByAppendingString:lastName];
    
    self.detailLabel.text = concatFullName;
    return NO;
}
@end
