//
//  RWWorkoutsListController.m
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 21.05.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import "RWWorkoutsListController.h"
#import "RWWorkoutDetailsController.h"

#import "RWAppDelegate.h"
#import "RWDataController.h"
#import "Workout.h"
#import "WorkoutVariant.h"
#import "RWWorkoutCell.h"

@interface RWWorkoutsListController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation RWWorkoutsListController

@synthesize fetchResultsController;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)initFetchController
{
    // init fetch controller
    self.fetchResultsController = [self.dataController getAllWorkouts];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [self.fetchResultsController.fetchedObjects count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWWorkoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //differ between your sections or if you
    //have only on section return a static value
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //execute segue programmatically
    //[self performSegueWithIdentifier: @"showWorkout" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showWorkout"]) {
        UITableViewCell *cell = (UITableViewCell *) ([[((UIButton*) sender) superview] superview]);
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Workout* workout = (Workout*)[self.fetchResultsController objectAtIndexPath:indexPath];
        WorkoutVariant *variant;
        
        NSArray *variants = [workout.childVariants allObjects];
        
        if (((UIButton*) sender).tag == 1){
            variant = variants [0];
        } else {
            variant = variants [1];
        }
        
        RWWorkoutDetailsController *controller = (RWWorkoutDetailsController *)segue.destinationViewController;
        controller.variant= variant;
    }
}

- (void)configureCell:(RWWorkoutCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Workout* workout = (Workout*)[self.fetchResultsController objectAtIndexPath:indexPath];
    
    // workout details
    cell.workoutName.text = workout.name;
    cell.numberLabel.text = [NSString stringWithFormat:@"# %d", workout.number];
    
    // get variants
    NSArray* array = [workout.childVariants allObjects];
    if ([array count] == 2){
        WorkoutVariant *variant1 = array[0];
        WorkoutVariant *variant2 = array[1];
        
        if (variant1.length > variant2.length)
        {
            // swap variants
            WorkoutVariant* temp = variant1;
            variant1 = variant2;
            variant2 = temp;
        }
        
        // show variants
        NSString *length1 = [NSString stringWithFormat:@"%d m", variant1.length];
        [cell.firstButton setTitle:length1 forState:UIControlStateNormal];
        
        NSString *length2 = [NSString stringWithFormat:@"%d m", variant2.length];
        [cell.secondButton setTitle:length2 forState:UIControlStateNormal];
        
        // TODO show times completed
        
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 70.0;
//}


- (IBAction)firstVariantClicked:(id)sender forEvent:(UIEvent *)event {
    [self performSegueWithIdentifier:@"showWorkout" sender:sender];
}

- (IBAction)secondVariantClicked:(id)sender forEvent:(UIEvent *)event {
    [self performSegueWithIdentifier:@"showWorkout" sender:sender];
}
@end

