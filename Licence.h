//
//  Licence.h
//  Licence Notifications
//
//  Created by rose on 14/9/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Vehicle;

@interface Licence : NSManagedObject

@property (nonatomic, retain) NSString * licenceName;
@property (nonatomic, retain) NSSet *vehicles;
@end

@interface Licence (CoreDataGeneratedAccessors)

- (void)addVehiclesObject:(Vehicle *)value;
- (void)removeVehiclesObject:(Vehicle *)value;
- (void)addVehicles:(NSSet *)values;
- (void)removeVehicles:(NSSet *)values;

@end
