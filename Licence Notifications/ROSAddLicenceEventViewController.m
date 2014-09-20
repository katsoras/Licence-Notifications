//
//  ROSAddLicenceEventViewController.m
//  Licence Notifications
//
//  Created by rose on 20/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import "ROSAddLicenceEventViewController.h"
#import "LicenceCell.h"
#import "Licence.h"

@interface ROSAddLicenceEventViewController ()
<NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation ROSAddLicenceEventViewController
//static NSString *CellIdentifier = @"LicenceCell";
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
    NSLog(@"%@",self.managedObjectContext);
    
    // Initialize Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Licence"];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"licenceName" ascending:YES]]];
    
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
    //
    //reegister custom cell class
    //[self.tableView
    //registerClass:[LicenceCell class]
    //forCellReuseIdentifier:CellIdentifier];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//
//implement NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"-------%d",[[self.fetchedResultsController sections]count]);
    return [[self.fetchedResultsController sections]count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sections=[self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo=[sections objectAtIndex:section];
    NSLog(@"-------%d",[sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LicenceCell *cell = (LicenceCell *)[tableView dequeueReusableCellWithIdentifier:@"LicenceCell"];
    //
    // Configure Table View Cell
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
- (void)configureCell:(LicenceCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //
    // Fetch Record
    Licence *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Update Cell
    [cell.nameLabel setText:record.licenceName];
    NSLog(@"NAME:------%@",record.licenceName);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    [cell.dateLabel setText:[dateFormatter stringFromDate:[NSDate date]]];
}
@end
