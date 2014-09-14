//
//  Vehicle.h
//  Licence Notifications
//
//  Created by rose on 14/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Licence;

@interface Vehicle : NSManagedObject

@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * registrationPlate;
@property (nonatomic, retain) NSSet *vehicleLicenses;
@end

@interface Vehicle (CoreDataGeneratedAccessors)

- (void)addVehicleLicensesObject:(Licence *)value;
- (void)removeVehicleLicensesObject:(Licence *)value;
- (void)addVehicleLicenses:(NSSet *)values;
- (void)removeVehicleLicenses:(NSSet *)values;

@end
