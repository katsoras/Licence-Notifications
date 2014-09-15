//
//  ROSTypePickerViewController.m
//  Licence Notifications
//
//  Created by rose on 14/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import "ROSTypePickerViewController.h"

NSString * const VEHICLE = @"Vehicle";
NSString * const DRIVER = @"Driver";

@interface ROSTypePickerViewController ()

@end

@implementation ROSTypePickerViewController {
    NSArray *_types;
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
    _types=@[VEHICLE,
             DRIVER];
    
    _selectedIndex = [_types indexOfObject:self.type];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_types count];
}

//
//cell configuration
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeCell"];
    cell.textLabel.text = _types[indexPath.row];
    
    
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
    NSString *type = _types[indexPath.row];
    //make callback
    [self.delegate typePickerViewController:self didSelectType:type];
}
@end
