//
//  RWDataController.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 20.05.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RWAppDelegate.h"

@class WorkoutVariant;
@interface RWDataController : NSObject <NSFetchedResultsControllerDelegate>

@property NSManagedObjectContext *context;
@property NSObject <NSFetchedResultsControllerDelegate> *fetchedResultsControllerDelegate;

// creation
- (RWDataController*) initWithAppDelegate:(RWAppDelegate *)delegate fetchedControllerDelegate:(NSObject <NSFetchedResultsControllerDelegate>*)fetchedResultsControllerDelegate;
-(RWDataController*) initWithAppDelegate:(RWAppDelegate *)delegate;

// fill
- (void) initialDatabaseFill;
- (void) tipsFill;
- (void) glossaryFill;

// workouts
- (NSFetchedResultsController*) getAllWorkouts;
- (void) addCompleteWorkoutEvent: (WorkoutVariant*) variant;

// tips
- (NSFetchedResultsController*) getAllTips;

// glossary
- (NSFetchedResultsController*) getAllGlossaryTopics;

@end
