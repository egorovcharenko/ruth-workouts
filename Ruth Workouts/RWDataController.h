//
//  RWDataController.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 20.05.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RWAppDelegate.h"

typedef enum
{
    MondaySelected       = 1 << 0,
    TuesdaySelected      = 1 << 1,
    WednesdaySelected    = 1 << 2,
    ThursdaySelected     = 1 << 3,
    FridaySelected       = 1 << 4,
    SaturdaySelected     = 1 << 5,
    SundaySelected       = 1 << 6
} WeekdaysSelection;


@class Workout;
@class WorkoutVariant;
@class WorkoutVariantEvent;
@class Plan;
@class Category;

@interface RWDataController : NSObject <NSFetchedResultsControllerDelegate>

@property NSManagedObjectContext *context;
@property NSObject <NSFetchedResultsControllerDelegate> *fetchedResultsControllerDelegate;

// creation
- (RWDataController*) initWithAppDelegate:(RWAppDelegate *)delegate fetchedControllerDelegate:(NSObject <NSFetchedResultsControllerDelegate>*)fetchedResultsControllerDelegate;
- (RWDataController*) initWithAppDelegate:(RWAppDelegate *)delegate;

// fill
- (void) initialDatabaseFill;
- (void) tipsFill;
- (void) glossaryFill;

// workouts
- (NSFetchedResultsController*) getAllDefaultWorkouts;
- (void) addCompleteWorkoutEvent: (WorkoutVariant*) variant;
- (WorkoutVariant*) getWorkoutVariantByNumber: (Workout*) workout number: (int) number;
- (WorkoutVariantEvent*) getLatestWorkoutVariantEvent: (WorkoutVariant*) variant;

// tips
- (NSFetchedResultsController*) getAllTips;

// glossary
- (NSFetchedResultsController*) getAllGlossaryTopics;

// plans
- (NSFetchedResultsController*) getAllPlans;
- (void) scheduleThePlan: (Plan*) plan;
- (void) scheduleThePlanExtended: (Plan*) plan startDate: (NSDate*)startDate startWorkoutNum:(int)startWorkoutNum skipFirstWorkoutWeekdayCheck:(BOOL)skipFirstWorkoutWeekdayCheck;
- (NSSet*) getCompletedWorkouts: (Plan*) plan;
- (NSFetchedResultsController*) getWorkoutsOfAPlan: (Plan*) plan;
- (Plan*) getPlanByNum:(int) planNum;
- (long) getCompletedWorkoutsNumber: (Plan*) plan;
- (NSDate*) getPlannedEndDate: (Plan*) plan;
- (Workout*) getNextUncompletedWorkout: (Plan*) plan;
- (Workout*) getWorkoutByNumber: (Plan*) plan number: (int) number;

// categories
- (NSFetchedResultsController*) getAllCategories;
- (Plan*) getPlanFromCategory: (Category*)category planNum:(int)planNum;

// general
- (void)saveData;

@end
