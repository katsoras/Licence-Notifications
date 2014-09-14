//
//  Vehicle.h
//  Licence Notifications
//
//  Created by rose on 14/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class VehicleLicence;

@interface Vehicle : NSManagedObject

@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * registrationPlate;
@property (nonatomic, retain) NSSet *vehicleLicenses;
@end

@interface Vehicle (CoreDataGeneratedAccessors)

- (void)addVehicleLicensesObject:(VehicleLicence *)value;
- (void)removeVehicleLicensesObject:(VehicleLicence *)value;
- (void)addVehicleLicenses:(NSSet *)values;
- (void)removeVehicleLicenses:(NSSet *)values;

@end
