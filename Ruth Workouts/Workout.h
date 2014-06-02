//
//  Workout.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 28.05.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Plan, WorkoutVariant;

@interface Workout : NSManagedObject

@property (nonatomic, retain) NSNumber * daysToNextWorkoutIdeal;
@property (nonatomic, retain) NSNumber * daysToNextWorkoutMax;
@property (nonatomic, retain) NSNumber * daysToNextWorkoutMin;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSDate * plannedDate;
@property (nonatomic, retain) NSNumber * selectedVariantNumber;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSDate * dateCompleted;
@property (nonatomic, retain) NSSet *childVariants;
@property (nonatomic, retain) Plan *parentPlan;
@end

@interface Workout (CoreDataGeneratedAccessors)

- (void)addChildVariantsObject:(WorkoutVariant *)value;
- (void)removeChildVariantsObject:(WorkoutVariant *)value;
- (void)addChildVariants:(NSSet *)values;
- (void)removeChildVariants:(NSSet *)values;

@end
