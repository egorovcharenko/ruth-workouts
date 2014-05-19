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


@class WorkoutVariant;
@class Plan;

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

// tips
- (NSFetchedResultsController*) getAllTips;

// glossary
- (NSFetchedResultsController*) getAllGlossaryTopics;

// plans
- (NSFetchedResultsController*) getAllPlans;
- (void) scheduleThePlan: (Plan*) plan;

@end
