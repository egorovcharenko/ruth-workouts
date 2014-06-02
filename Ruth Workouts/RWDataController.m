//
//  RWDataController.m
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 20.05.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import "RWDataController.h"
#import "Workout.h"
#import "WorkoutVariant.h"
#import "Section.h"
#import "SectionActivity.h"
#import "WorkoutVariantEvent.h"
#import "Tip.h"
#import "GlossaryTopic.h"
#import "GlossaryTermin.h"
#import "Plan.h"

#import "RWAppDelegate.h"


@implementation RWDataController
@synthesize context;

-(RWDataController*) initWithAppDelegate:(RWAppDelegate *)delegate fetchedControllerDelegate:(NSObject <NSFetchedResultsControllerDelegate>*)fetchedResultsControllerDelegate;
{
    context = [delegate managedObjectContext];
    _fetchedResultsControllerDelegate = fetchedResultsControllerDelegate;
    return self;
}

-(RWDataController*) initWithAppDelegate:(RWAppDelegate *)delegate;
{
    context = [delegate managedObjectContext];
    return self;
}

-(void) initialDatabaseFill
{
    [self workoutsFill];
    [self tipsFill];
    [self glossaryFill];
}

- (void)saveData
{
    NSError *err = nil;
    [context save:&err];
    
    if (err != nil) {
        NSLog(@"error saving managed object context: %@", err);
    }
}

-(void) workoutsFill
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"workouts" ofType:@"plist"];
    NSArray *items = [NSArray arrayWithContentsOfFile:path];
    
    // load all plans
    for (NSDictionary *dict in items) {
        // Plans
        Plan *plan = [NSEntityDescription insertNewObjectForEntityForName:@"Plan" inManagedObjectContext:context];
        plan.number = [[dict objectForKey:@"number"] integerValue];
        plan.name = [dict objectForKey:@"name"];
        plan.desc = [dict objectForKey:@"desc"];
        plan.weekdaysSelected = [[dict objectForKey:@"weekdaysSelected"] integerValue];
        plan.status = @"Awaiting";
        plan.nextWorkout = nil;
        
        // workouts
        NSArray *workouts = [dict objectForKey:@"workouts"];
        
        // load all workouts of a plan
        for (NSDictionary *dict in workouts) {
            // workouts
            Workout *workout = [NSEntityDescription insertNewObjectForEntityForName:@"Workout" inManagedObjectContext:context];
            [plan addChildWorkoutsObject:workout];
            
            workout.number = [dict objectForKey:@"number"];
            workout.name = [dict objectForKey:@"name"];
            workout.daysToNextWorkoutIdeal = [dict objectForKey:@"daysToNextWorkoutIdeal"];
            workout.daysToNextWorkoutMax = [dict objectForKey:@"daysToNextWorkoutMax"];
            workout.daysToNextWorkoutMin = [dict objectForKey:@"daysToNextWorkoutMin"];
            workout.selectedVariantNumber = [NSNumber numberWithInt:1];
            workout.status = @"Not planned";
            
            // variants
            NSArray *variants = [dict objectForKey:@"variants"];
            int variantNumber = 1;
            for (NSDictionary *dict2 in variants) {
                WorkoutVariant *variant = [NSEntityDescription insertNewObjectForEntityForName:@"WorkoutVariant" inManagedObjectContext:context];
                [workout addChildVariantsObject:variant];
                
                //variant.length = [[dict2 objectForKey:@"length"] integerValue];
                int variantLen = 0;
                
                variant.number = [NSNumber numberWithInteger:variantNumber];
                variantNumber ++;
                
                // sections
                NSArray *sections = [dict2 objectForKey:@"sections"];
                for (NSDictionary *dict3 in sections) {
                    Section *section = [NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:context];
                    [variant addChildSectionsObject:section];
                    
                    section.order = [[dict3 objectForKey:@"order"] integerValue];
                    //section.length = [[dict3 objectForKey:@"length"] integerValue];
                    section.name = [dict3 objectForKey:@"name"];
                    
                    int sectionLen = 0;
                    // activities
                    NSArray *activities = [dict3 objectForKey:@"activities"];
                    for (NSDictionary *dict4 in activities) {
                        SectionActivity *activity = [NSEntityDescription insertNewObjectForEntityForName:@"SectionActivity" inManagedObjectContext:context];
                        [section addChildActivitiesObject:activity];
                        
                        activity.order = [[dict4 objectForKey:@"order"] integerValue];
                        activity.name = [dict4 objectForKey:@"name"];
                        activity.details = [dict4 objectForKey:@"details"];
                        activity.lenMultiplier = [[dict4 objectForKey:@"len_multiplier"] integerValue];
                        activity.len = [[dict4 objectForKey:@"len"] integerValue];
                        activity.lenDetails = [dict4 objectForKey:@"len_details"];
                        
                        sectionLen += activity.len * activity.lenMultiplier;
                    }
                    
                    // calculate section length automatically
                    section.length = sectionLen;
                    variantLen += sectionLen;
                }
                
                // calculate total length automatically
                variant.length = [NSNumber numberWithInteger:variantLen];
            }
        } // workout end
    } //  plan end
    
    [self saveData];
}

- (NSFetchedResultsController*) getAllDefaultWorkouts
{
    return [self getAllWorkoutsOfPlan:0];
}

- (NSFetchedResultsController*) getAllWorkoutsOfPlan: (NSInteger)parentPlanNum
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Workout" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"parentPlan.number=%d", parentPlanNum];
    [fetchRequest setPredicate:fetchPredicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    //int count = [aFetchedResultsController.fetchedObjects count];
    //NSLog(@"Workouts number = %d", count);
    
    NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return aFetchedResultsController;
}

- (NSFetchedResultsController*) getAllTips
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tip" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    //int count = [aFetchedResultsController.fetchedObjects count];
    //NSLog(@"Workouts number = %d", count);
    
    NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return aFetchedResultsController;
}

- (NSFetchedResultsController*) getAllGlossaryTopics
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GlossaryTopic" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    //int count = [aFetchedResultsController.fetchedObjects count];
    //NSLog(@"Workouts number = %d", count);
    
    NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return aFetchedResultsController;
}

- (Plan*) getPlanByNum:(int) planNum
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Plan" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"number=%d", planNum];
    [fetchRequest setPredicate:fetchPredicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    NSIndexPath* ip = [NSIndexPath indexPathForRow:0 inSection:0];
    Plan* result = [aFetchedResultsController objectAtIndexPath:ip];
    
    return result;
}

// plans
- (NSFetchedResultsController*) getAllPlans
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Plan" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
        [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"number>0"];
    [fetchRequest setPredicate:fetchPredicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    int count = [aFetchedResultsController.fetchedObjects count];
    NSLog(@"Plans count = %d", count);
    
    NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return aFetchedResultsController;
}

- (void) addCompleteWorkoutEvent: (WorkoutVariant*) variant
{
    WorkoutVariantEvent *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"WorkoutVariantEvent" inManagedObjectContext:context];
    
    newEvent.date = [NSDate date];
    newEvent.comment = @"";
    newEvent.totalLength = [NSNumber numberWithInt: variant.length];
    
    NSError *err = nil;
    [context save:&err];
    
    if (err != nil) {
        NSLog(@"error saving managed object context: %@", err);
    }

}

- (void) tipsFill
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tips" ofType:@"plist"];
    NSArray *items = [NSArray arrayWithContentsOfFile:path];
    
    // load all data
    for (NSDictionary *dict in items) {
        Tip *tip = [NSEntityDescription insertNewObjectForEntityForName:@"Tip" inManagedObjectContext:context];
        
        tip.number = [[dict objectForKey:@"number"] integerValue];
        tip.text = [dict objectForKey:@"text"];
    }
    
    NSError *err = nil;
    [context save:&err];
    
    if (err != nil) {
        NSLog(@"error saving managed object context: %@", err);
    }
}


- (void) glossaryFill
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"glossary" ofType:@"plist"];
    NSArray *items = [NSArray arrayWithContentsOfFile:path];
    
    int topicOrder = 0;
    // load all data
    for (NSDictionary *dict in items) {
        GlossaryTopic *topic = [NSEntityDescription insertNewObjectForEntityForName:@"GlossaryTopic" inManagedObjectContext:context];
        
        topic.name = [dict objectForKey:@"topic_name"];
        topic.order = ++ topicOrder;
        
        // termins
        int terminOrder = 0;
        NSArray *content = [dict objectForKey:@"topic_content"];
        for (NSDictionary *dict2 in content) {
            GlossaryTermin *termin = [NSEntityDescription insertNewObjectForEntityForName:@"GlossaryTermin" inManagedObjectContext:context];
            
            termin.name = [dict2 objectForKey:@"termin"];
            termin.definition = [dict2 objectForKey:@"definition"];
            termin.order = ++ terminOrder;
            
            [topic addTopicTerminsObject:termin];
        }
    }
    
    NSError *err = nil;
    [context save:&err];
    
    if (err != nil) {
        NSLog(@"error saving managed object context: %@", err);
    }
}

- (Workout *)getWorkoutByNumber:(int)rollingWorkoutNum plan:(Plan *)plan
{
    Workout *rollingWorkout= nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"number == %d", rollingWorkoutNum];
    NSSet *filteredArray = [plan.childWorkouts filteredSetUsingPredicate:predicate];
    if ([filteredArray count] > 0) {
        rollingWorkout = [filteredArray anyObject];
    }
    return rollingWorkout;
}

- (void) scheduleThePlan: (Plan*) plan
{
    // set plan's properties
    plan.status = @"Active";
    
    NSDate* rollingDate = plan.startDate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:rollingDate];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    
    //rollingDate (midnight);
    NSDate *rollingDateMidnight = [cal dateByAddingComponents:components toDate:rollingDate options:0];
    
    int deltaDays = 10; // default value for first search
    
    // set workouts properties
    for (int wnum = 1; wnum <= [plan.childWorkouts count]; wnum ++) {
        Workout* rollingWorkout = [self getWorkoutByNumber:wnum plan:plan];
    
        for (int i = 0; i <= 10 /* max number*/; i ++) {
            // go thru all the days and set the date for the rolling workout
            NSDateComponents *weekdayComponents = [cal components:(NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:rollingDateMidnight];
            NSInteger weekday = [weekdayComponents weekday] - [cal firstWeekday];
            
            int weekdayBit = 1 << (weekday-1);
            
            if (weekdayBit & plan.weekdaysSelected){
                rollingWorkout.plannedDate = rollingDateMidnight;
                NSLog(@"Found place for workout, weekday:%ld, date:%@", (long)weekday, rollingDateMidnight);
                break;
            } else {
                rollingDateMidnight = [rollingDateMidnight dateByAddingTimeInterval:60*60*24 * 1];
                if (i > deltaDays) {
                    NSLog(@"Not found place for workout");
                    // TODO show error
                }
            }
        }
        
        int daysToAdd = [rollingWorkout.daysToNextWorkoutMin integerValue];
        rollingDateMidnight = [rollingDateMidnight dateByAddingTimeInterval:60*60*24 * daysToAdd];
        
        deltaDays =[rollingWorkout.daysToNextWorkoutMax integerValue] - [rollingWorkout.daysToNextWorkoutMin integerValue];
        
    }
    
    // display warning if the rest period is out of bounds and the option to cancel the plan
    
    // social?
    
    // set next workout to 1
    plan.nextWorkout = [self getWorkoutByNumber:1 plan:plan];
    
    // save data to DB
    NSError *err = nil;
    [context save:&err];
    
    NSLog(@"Saved context");
    
    if (err != nil) {
        NSLog(@"error saving managed object context: %@", err);
    }
    
}

- (NSSet*) getCompletedWorkouts: (Plan*) plan
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status =%@", @"Completed"];
    return [plan.childWorkouts filteredSetUsingPredicate:predicate];
}

- (WorkoutVariant*) getWorkoutVariantByNumber: (Workout*) workout number: (int) number
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"number = %d", number];
    return [[workout.childVariants filteredSetUsingPredicate:predicate] anyObject];
}

- (WorkoutVariantEvent*) getLatestWorkoutVariantEvent: (WorkoutVariant*) variant
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parentVariant = %@", variant];
    NSSortDescriptor *date = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    
    return [[[variant.variantEvents filteredSetUsingPredicate:predicate] sortedArrayUsingDescriptors:[NSArray arrayWithObjects: date, nil] ] firstObject];
}

- (NSFetchedResultsController*) getWorkoutsOfAPlan: (Plan*) plan
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Workout" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"parentPlan.number=%d", plan.number];
    [fetchRequest setPredicate:fetchPredicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    int count = [aFetchedResultsController.fetchedObjects count];
    NSLog(@"Plan workouts count = %d", count);
    
    NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return aFetchedResultsController;
}


@end
