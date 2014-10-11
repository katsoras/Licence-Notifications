//
//  ROSNotificationsViewController.m
//  Licence Notifications
//
//  Created by rose on 9/10/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import "ROSNotificationsViewController.h"
#import "ROSNotificationViewCell.h"
#import "Notification.h"
#import "Licence.h"
@interface ROSNotificationsViewController ()
@property (strong) NSMutableArray *notifications;
//
//formatter for licence dates
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation ROSNotificationsViewController

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
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Notification"];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"expireDate" ascending:NO]]];
    
    self.notifications = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.notifications.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ROSNotificationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //
    // Configure the cell...
    Notification * notification= [self.notifications objectAtIndex:indexPath.row];
    cell.notificateExpireDate.text=
    [self.dateFormatter stringFromDate:notification.expireDate];
    cell.notificateLicenceName.text=notification.licence.licenceName;
    
    NSComparisonResult result =
    [[NSDate date] compare:notification.expireDate];
    if (result==NSOrderedDescending) {
        cell.notificateLicenceName.textColor = [UIColor redColor];
    }
    
    
    
    return cell;
}
@end
