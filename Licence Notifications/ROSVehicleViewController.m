//
//  ROSvehicleLicenceViewController.m
//  Licence Notifications
//
//  Created by rose on 13/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import "ROSVehicleViewController.h"
#import "ROSVehicleViewCell.h"
#import "ROSEditVehicleViewController.h"
#import "Vehicle.h"
#import "ROSUtility.h"
//
//class extension
@interface ROSVehicleViewController ()<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
//
//holds selected index path
@property (strong, nonatomic) NSIndexPath *selection;
@end

@implementation ROSVehicleViewController{
    NSMutableArray *searchResults;
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
    
    // Initialize Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Vehicle"];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"model" ascending:YES]]];
    
    // Initialize Fetched Results Controller
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    // Configure Fetched Results Controller
    [self.fetchedResultsController setDelegate:self];
    
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [searchResults removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"registrationPlate contains[c] %@", searchText];
    searchResults = [NSMutableArray arrayWithArray:[self.fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:resultPredicate]];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

//
//implement NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}
- (IBAction) editVehicleLicence:(id)sender {
    [self.tableView setEditing:![self.tableView isEditing] animated:YES];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self configureCell:(ROSVehicleViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] tableView:self.tableView atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//
//implementing UItableview datasource
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        if (record) {
            [self.fetchedResultsController.managedObjectContext deleteObject:record];
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections]count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    }else{
        NSArray *sections=[self.fetchedResultsController sections];
        id<NSFetchedResultsSectionInfo> sectionInfo=[sections objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //
    // Dequeue Reusable Cell
    ROSVehicleViewCell *cell = [self.tableView
                                dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //
    // Configure the cell...
    if (cell == nil) {
        cell = [[ROSVehicleViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //
    // Configure Table View Cell
    [self configureCell:cell tableView:tableView atIndexPath:indexPath];
    return cell;
}
- (void)configureCell:(ROSVehicleViewCell *)cell tableView:(UITableView *) tableView atIndexPath:(NSIndexPath *)indexPath {
    // Fetch Record
    Vehicle *record;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        record = [searchResults objectAtIndex:indexPath.row];
    }
    
    else {
        record= [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    //
    // Update Cell
    [cell.registerPlateLabelField setText:record.registrationPlate];
    [cell.modelLabelField setText:record.model];
    if([ROSUtility checkForNotificationsAllUpdated:record.notifications]){
        cell.statusImage.image=[UIImage imageNamed:@"Warning.png"];
    }
}
//
//implementing table view delegate

//
//notify when the detailed disclosure button is tapped
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self setSelection:indexPath];
    
    //
    // Perform Segue
    [self performSegueWithIdentifier:@"EditVehicleLicenceViewController" sender:self];
}

- (IBAction)sequeAdd:(id)sender {
    [self performSegueWithIdentifier:@"EditVehicleLicenceViewController" sender:self];
}
//
//prepare for segue and set properties to addVehicle and editVehicle controllers
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /*if ([segue.identifier isEqualToString:@"AddVehicleLicenceViewController"]) {
        // Obtain Reference to View Controller
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        ROSAddVehicleViewController *vc = (ROSAddVehicleViewController *)[nc topViewController];
        // Configure View Controller
        [vc setManagedObjectContext:self.managedObjectContext];
    }*/
    if([segue.identifier isEqualToString:@"EditVehicleLicenceViewController"]){
        // Obtain Reference to View Controller
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        ROSEditVehicleViewController *vc = (ROSEditVehicleViewController *)[nc topViewController];
        
        //
        // Configure View Controller
        [vc setManagedObjectContext:self.managedObjectContext];
        if(self.selection){
            Vehicle *record =nil;
            if(self.searchDisplayController.active){
                record = [searchResults objectAtIndex:self.selection.row];
            }
            else {
                record = [self.fetchedResultsController objectAtIndexPath:self.selection];
            }
            if (record) {
                [vc setRecord:record];
            }
            
            // Reset Selection
            [self setSelection:nil];
        }
    }
}
@end
