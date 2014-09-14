//
//  VehicleLicence.h
//  Licence Notifications
//
//  Created by rose on 14/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface VehicleLicence : NSManagedObject

@property (nonatomic, retain) NSString * licenceName;
@property (nonatomic, retain) NSSet *vehicles;
@end

@interface VehicleLicence (CoreDataGeneratedAccessors)

- (void)addVehiclesObject:(NSManagedObject *)value;
- (void)removeVehiclesObject:(NSManagedObject *)value;
- (void)addVehicles:(NSSet *)values;
- (void)removeVehicles:(NSSet *)values;

@end
