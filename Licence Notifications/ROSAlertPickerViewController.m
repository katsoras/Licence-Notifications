//
//  ROSAlertPickerViewController.m
//  Licence Notifications
//
//  Created by rose on 17/10/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import "ROSAlertPickerViewController.h"
#import "ROSUtility.h"
@interface ROSAlertPickerViewController ()

@end
@implementation ROSAlertPickerViewController{
    NSUInteger _selectedIndex;
    NSArray *_alertTypes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _alertTypes=[ROSUtility alertTypes];
    _selectedIndex = [_alertTypes indexOfObject:self.alertType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_alertTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertCell"];
    cell.textLabel.text = _alertTypes[indexPath.row];
    
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
    if (_selectedIndex != NSNotFound) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    _selectedIndex = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    NSNumber *index=[NSNumber numberWithInteger:indexPath.row];
    [self.delegate alertPickerViewController:self didSelectAlert:index];
}
@end
