//
//  Workout.m
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 28.05.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import "Workout.h"
#import "Plan.h"
#import "WorkoutVariant.h"


@implementation Workout

@dynamic daysToNextWorkoutIdeal;
@dynamic daysToNextWorkoutMax;
@dynamic daysToNextWorkoutMin;
@dynamic name;
@dynamic number;
@dynamic plannedDate;
@dynamic selectedVariantNumber;
@dynamic status;
@dynamic dateCompleted;
@dynamic childVariants;
@dynamic parentPlan;

@end
