//
//  Plan.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 12.06.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Workout;

@interface Plan : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSNumber * weekdaysSelected;
@property (nonatomic, retain) NSString * activity;
@property (nonatomic, retain) NSNumber * displayNumber;
@property (nonatomic, retain) NSNumber * orderInCategory;
@property (nonatomic, retain) NSSet *childWorkouts;
@property (nonatomic, retain) Workout *nextWorkout;
@property (nonatomic, retain) Category *parentCategory;
@end

@interface Plan (CoreDataGeneratedAccessors)

- (void)addChildWorkoutsObject:(Workout *)value;
- (void)removeChildWorkoutsObject:(Workout *)value;
- (void)addChildWorkouts:(NSSet *)values;
- (void)removeChildWorkouts:(NSSet *)values;

@end
