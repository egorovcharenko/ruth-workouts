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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"workouts" ofType:@"plist"];
    NSArray *items = [NSArray arrayWithContentsOfFile:path];
    
    // load all data
    for (NSDictionary *dict in items) {
        // workouts
        Workout *workout = [NSEntityDescription insertNewObjectForEntityForName:@"Workout" inManagedObjectContext:context];
        workout.number = [[dict objectForKey:@"number"] integerValue];
        workout.name = [dict objectForKey:@"name"];
        
        // variants
        NSArray *variants = [dict objectForKey:@"variants"];
        for (NSDictionary *dict2 in variants) {
            WorkoutVariant *variant = [NSEntityDescription insertNewObjectForEntityForName:@"WorkoutVariant" inManagedObjectContext:context];
            [workout addChildVariantsObject:variant];
            
            variant.length = [[dict2 objectForKey:@"length"] integerValue];
            
            // sections
            NSArray *sections = [dict2 objectForKey:@"sections"];
            for (NSDictionary *dict3 in sections) {
                Section *section = [NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:context];
                [variant addChildSectionsObject:section];
                
                section.length = [[dict3 objectForKey:@"length"] integerValue];
                section.name = [dict3 objectForKey:@"name"];
                
                // activities
                NSArray *activities = [dict3 objectForKey:@"activities"];
                for (NSDictionary *dict4 in activities) {
                    SectionActivity *activity = [NSEntityDescription insertNewObjectForEntityForName:@"SectionActivity" inManagedObjectContext:context];
                    [section addChildActivitiesObject:activity];
                    
                    activity.name = [dict4 objectForKey:@"name"];
                    activity.details = [dict4 objectForKey:@"details"];
                    activity.lenMultiplier = [[dict4 objectForKey:@"len_multiplier"] integerValue];
                    activity.len = [[dict4 objectForKey:@"len"] integerValue];
                    activity.lenDetails = [dict4 objectForKey:@"len_details"];

                }
            }
        }
    }
    
    NSError *err = nil;
    [context save:&err];
    
    if (err != nil) {
        NSLog(@"error saving managed object context: %@", err);
    }
}

- (NSFetchedResultsController*) getAllWorkouts
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Workout" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    int count = [aFetchedResultsController.fetchedObjects count];
    NSLog(@"Workouts number = %d", count);
    
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