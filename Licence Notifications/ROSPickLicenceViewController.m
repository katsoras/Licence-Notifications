//
//  ROSPickLicenceViewController.m
//  Licence Notifications
//
//  Created by rose on 21/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import "ROSPickLicenceViewController.h"
#import "Licence.h"

@interface ROSPickLicenceViewController ()
    @property (strong) NSMutableArray *licences;
@end

@implementation ROSPickLicenceViewController{
    NSUInteger _selectedIndex;
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
    
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Licence"];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"type == %@",self.type];
    [fetchRequest setPredicate:predicate];
    self.licences = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    //
    //previous selection
    if(self.licence){
        _selectedIndex=[self.licences indexOfObject:self.licence];
    }
    //
    //no previous selections, first add action
    else {
        _selectedIndex=-1;
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.licences.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LicenceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    Licence *licence = [self.licences objectAtIndex:indexPath.row];
    [cell.textLabel setText:licence.licenceName];
    
    if (indexPath.row == _selectedIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
    //remove checkmark from the cell tha previous selected
    if (_selectedIndex != NSNotFound) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:
                                 [NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    //
    //set new checkmark
    _selectedIndex = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    Licence *licence = self.licences[indexPath.row];
    //
    //make callback
    [self.delegate eventPickerViewController:self
                               didSelectType: licence andDate:nil andNotification:nil];
}
@end