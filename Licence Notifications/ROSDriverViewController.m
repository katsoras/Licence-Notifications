//
//  ROSDriverViewController.m
//  Licence Notifications
//
//  Created by rose on 17/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import "ROSDriverViewController.h"
#import "ROSAddDriverViewController.h"
#import "ROSEditDriverViewController.h"
#import "Driver.h"


@interface ROSDriverViewController ()<NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *
fetchedResultsController;
//
//holds selected index path
@property (strong, nonatomic) NSIndexPath *selection;

@end


@implementation ROSDriverViewController
static NSString *CellIdentifier = @"Cell Identifier";

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
    //
    // Initialize Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Driver"];
    
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]]];
    
    //
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
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) editVehicleLicence:(id)sender {
    [self.tableView setEditing:![self.tableView isEditing] animated:YES];
}

//
//implement NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
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
            [self configureCell:(UITableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
    
}

//
//implementing UItableview datasource
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
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
    NSArray *sections=[self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo=[sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue Reusable Cell
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //
    // Configure Table View Cell
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //
    // Fetch Record
    Driver *record = [self.fetchedResultsController objectAtIndexPath:indexPath];

    //
    // Update Cell
    [cell.textLabel setText:[[record.firstName stringByAppendingString:@" "] stringByAppendingString:record.lastName]];
    
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
}

//
//implementing table view delegate

//
//notify when the detailed disclosure button is tapped
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self setSelection:indexPath];
    //
    // Perform Segue
    [self performSegueWithIdentifier:@"EditDriverViewController" sender:self];
}

//
//prepare for segue and set properties to addVehicle and editVehicle controllers
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"AddDriverViewController"]) {
        
        // Obtain Reference to View Controller
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        
        ROSAddDriverViewController *vc = (ROSAddDriverViewController *)
        [nc topViewController];
        //
        // Configure View Controller
        [vc setManagedObjectContext:self.managedObjectContext];
    }
    else if([segue.identifier
              isEqualToString:@"EditDriverViewController"]){
        //
        // Obtain Reference to View Controller
        ROSEditDriverViewController *vc = (ROSEditDriverViewController *)[segue destinationViewController];
        
        //
        // Configure View Controller
        [vc setManagedObjectContext:self.managedObjectContext];
        if (self.selection) {
            //
            // Fetch Record
            Driver *record = [self.fetchedResultsController objectAtIndexPath:self.selection];
            
            if (record) {
                [vc setRecord:record];
            }
            
            
            //
            // Reset Selection
            [self setSelection:nil];
        }
    }
}
@end
