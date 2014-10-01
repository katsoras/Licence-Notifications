//
//  ROSAddLicenceEventViewController.m
//  Licence Notifications
//
//  Created by rose on 20/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import "ROSAddVehicleLicenceEventViewController.h"
#import "ROSPickLicenceViewController.h"
#import "ROSTypePickerViewController.h"
#define kDatePickerIndex 2
#define kDatePickerCellHeight 164

@interface ROSAddVehicleLicenceEventViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) NSDate *selectedExpireDate;
@property (assign) BOOL datePickerIsShowing;
@end

@implementation ROSAddVehicleLicenceEventViewController{
    Licence * _licence;
}

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
    //
    //EDIT MODE: extract notification values
    if(self.notification){
        _licence=self.notification.licence;
        self.licenceNameLabel.text=_licence.licenceName;
        self.selectedExpireDate=self.notification.expireDate;
    }
    
    //
    //add mode
    else {
        self.selectedExpireDate=[NSDate date];
    }
    [self setupExpireDate];
    [self hideDatePickerCell];
}

- (IBAction) done{
    [self.delegate eventPickerViewController:self
                               didSelectType: _licence andDate:self.selectedExpireDate andNotification:self.notification];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupExpireDate {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.expireDateLabel.text = [self.dateFormatter stringFromDate:self.selectedExpireDate];
    
    self.expireDateLabel.textColor = [self.tableView tintColor];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%d",indexPath.row);
    CGFloat height = self.tableView.rowHeight;
    
    if (indexPath.row == kDatePickerIndex){
        height = self.datePickerIsShowing ? kDatePickerCellHeight : 0.0f;
    }
    
    return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1){
        
        if (self.datePickerIsShowing){
            
            [self hideDatePickerCell];
            
        }else {
            
          //[self.activeTextField resignFirstResponder];
            
            [self showDatePickerCell];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)hideDatePickerCell {
    
    self.datePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.datePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.datePicker.hidden = YES;
                     }];
}
- (void)showDatePickerCell {
    
    self.datePickerIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.datePicker.hidden = NO;
    self.datePicker.alpha = 0.0f;
    [UIView animateWithDuration:0.25 animations:^{
        self.datePicker.alpha = 1.0f;
    }];
}
- (IBAction)pickerDateChanged:(UIDatePicker *)sender {
    self.expireDateLabel.text =  [self.dateFormatter stringFromDate:sender.date];
    self.selectedExpireDate = sender.date;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PickLicence"]) {
        ROSPickLicenceViewController *typePickerViewController = segue.destinationViewController;
        
        typePickerViewController.managedObjectContext=self.managedObjectContext;
        
        typePickerViewController.delegate = self;
        //
        //
        if(_licence){
            typePickerViewController.licence=_licence;
        }
        typePickerViewController.type = self.type;
    }
}

-(void) eventPickerViewController:(UITableViewController *)controller didSelectType:(Licence *) licence andDate:(NSDate *)date andNotification:(Notification *)notification{
    
    _licence=licence;
    self.licenceNameLabel.text =licence.licenceName;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
