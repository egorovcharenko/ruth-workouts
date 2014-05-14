//
//  Plan.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 14.05.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout;

@interface Plan : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) NSTimeInterval startDate;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic) int16_t number;
@property (nonatomic, retain) NSSet *childWorkouts;
@end

@interface Plan (CoreDataGeneratedAccessors)

- (void)addChildWorkoutsObject:(Workout *)value;
- (void)removeChildWorkoutsObject:(Workout *)value;
- (void)addChildWorkouts:(NSSet *)values;
- (void)removeChildWorkouts:(NSSet *)values;

@end
