//
//  RWAppDelegate.m
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 11.05.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import "RWAppDelegate.h"

#import "RWDataController.h"

#import "RWWorkoutsListController.h"

#import "Appirater.h"

#import "RWHelper.h"

#import "Plan.h"

@implementation RWAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void) upgrade:(RWDataController*) dataController
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *dueDatesArray = [[NSMutableArray alloc] initWithObjects:
                                     [defaults objectForKey:@"traing1complete"],
                                     [defaults objectForKey:@"traing2complete"],
                                     [defaults objectForKey:@"traing3complete"],
                                     [defaults objectForKey:@"traing4complete"],
                                     [defaults objectForKey:@"traing5complete"],
                                     [defaults objectForKey:@"traing6complete"],
                                     [defaults objectForKey:@"traing7complete"],
                                     [defaults objectForKey:@"traing8complete"],
                                     [defaults objectForKey:@"traing9complete"],
                                     [defaults objectForKey:@"traing10complete"],
                                     [defaults objectForKey:@"traing11complete"],
                                     [defaults objectForKey:@"traing12complete"],
                                     [defaults objectForKey:@"traing13complete"],
                                     [defaults objectForKey:@"traing14complete"],
                                     [defaults objectForKey:@"traing15complete"],
                                     [defaults objectForKey:@"traing16complete"],
                                     [defaults objectForKey:@"traing17complete"],
                                     [defaults objectForKey:@"traing18complete"],
                                     nil];
    if (dueDatesArray.count == 0)
        return;
    
    for (int i = 0; i < 18; i ++) {
        //NSLog(@"%@", [dueDatesArray objectAtIndex:i]);
        if([[dueDatesArray objectAtIndex:i] isEqualToString:@"TT"]) {
            [dataController setCurrentTrainingAtSwimAMileTo:i datesArray:dueDatesArray];
            
            // change start date
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd.MM.yyyy"];
            NSDate* appStartDate = [formatter dateFromString:[defaults objectForKey:@"applicationLounchDate"]];
            [dataController getPlanByNum:1].startDate = appStartDate;
            
            [dataController saveData];
            break;
        }
    }
}

- (BOOL)application: (UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Appirater setAppId:@"587366798"];
    // Override point for customization after application launch.
    
    //UITabBarController *navigationController = (UITabBarController *)self.window.rootViewController;
    //RWWorkoutsListController *controller = [navigationController.viewControllers objectAtIndex:0];
    //controller.managedObjectContext = self.managedObjectContext;
    
    // on first run - do the initial database load
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"firstRun"])
    {
        [defaults setObject:[NSDate date] forKey:@"firstRun"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self firstRun];
    }
    
    if (![defaults objectForKey:@"firstRun14"])
    {
        [defaults setObject:[NSDate date] forKey:@"firstRun14"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self firstRun14];
    }
    
    // set background
    //[self.window setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    
    // set global tint color
    //if ([[UIView appearance] respondsToSelector:@selector(setTintColor:)]) {
    [[[UIApplication sharedApplication] delegate] window].tintColor = [RWHelper sharedInstance].unrealFoodPills;
    //}
    
    // appirater setup
    [Appirater setDaysUntilPrompt:5];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    //[Appirater setDebug:YES];
    
    [Appirater appLaunched:YES];
    

    return YES;
}
- (void) applicationWillEnterForeground:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Ruth_Workouts" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Ruth_Workouts.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void) firstRun
{
    RWDataController *dataController = [[RWDataController alloc] initWithAppDelegate:self];
    [dataController initialDatabaseFill];
    
    // updrage if needed
    [self upgrade:dataController];
}

- (void) firstRun14
{
    RWDataController *dataController = [[RWDataController alloc] initWithAppDelegate:self];
    [dataController workoutsFill14];
    
    // change places - swim a mile and prepare
    Plan* swimAMilePlan = [dataController getPlanByNum:1];
    swimAMilePlan.orderInCategory = [NSNumber numberWithInt:1];
    
    Plan* preparationForSwimAMile = [dataController getPlanByNum:4];
    preparationForSwimAMile.orderInCategory = [NSNumber numberWithInt:0];
    
    [dataController saveData];
}


@end
