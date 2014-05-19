//
//  Plan.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 18.05.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout;

@interface Plan : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) int16_t number;
@property (nonatomic) NSDate* startDate;
@property (nonatomic, retain) NSString * status;
@property (nonatomic) int16_t weekdaysSelected;
@property (nonatomic, retain) NSSet *childWorkouts;
@property (nonatomic, retain) Workout *nextWorkout;
@end

@interface Plan (CoreDataGeneratedAccessors)

- (void)addChildWorkoutsObject:(Workout *)value;
- (void)removeChildWorkoutsObject:(Workout *)value;
- (void)addChildWorkouts:(NSSet *)values;
- (void)removeChildWorkouts:(NSSet *)values;

@end
