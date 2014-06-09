//
//  RWPlansController.m
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 14.05.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import "RWPlansController.h"

#include "RWPlanCell.h"
#include "Plan.h"
#include "RWPlanStartViewController.h"
#include "Workout.h"
#include "RWPlanDetailsViewController.h"


@interface RWPlansController ()

@end

@implementation RWPlansController

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
    self.fetchResultsController = [self.dataController getAllPlans];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = (int)[self.fetchResultsController.fetchedObjects count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
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

- (int) daysDiffFrom:(NSDate *) firstDate to:(NSDate*)secondDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:firstDate
                                                 toDate:secondDate
                                                options:0];
    
    return (int)components.day;
}

- (void)configureCell:(RWPlanCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Plan* plan = (Plan*)[self.fetchResultsController objectAtIndexPath:indexPath];
    
    // plan details
    cell.numberLabel.text = [NSString stringWithFormat:@"%d", plan.number];
    cell.nameLabel.text = plan.name;
    cell.descLabel.text = plan.desc;
    
    // set tags
    cell.startButton.tag = plan.number;
    cell.tag = plan.number;
    
    
    if ([plan.status isEqualToString:@"Active"]) {
        [cell.startButton setHidden:true];
        
        // start date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
        NSDate *date = plan.startDate;
        cell.startDateLabel.text = [NSString stringWithFormat:@"Started on %@",[dateFormatter stringFromDate:date]];
        
        // next training
        if (plan.nextWorkout == nil){
            // plan completed
            NSDate* datePlanCompleted = [self.dataController getWorkoutByNumber:plan number:(int)plan.childWorkouts.count].dateCompleted;
            cell.nextTrainingLabel.text = [NSString stringWithFormat:@"Plan completed on %@!",[dateFormatter stringFromDate:datePlanCompleted]];
        } else {
            NSDate* nextPlannedDate = plan.nextWorkout.plannedDate;
            [cell.nextTrainingLabel setHidden:false];
            int daysToWorkout = [self daysDiffFrom:plan.nextWorkout.plannedDate to:[NSDate date]];
            if (daysToWorkout == 0){
                // workout is today
                cell.nextTrainingLabel.text = @"Next workout is today!";
                cell.nextTrainingLabel.textColor = [UIColor colorWithRed:243.0/255.0 green:134.0/255.0 blue:48.0/255.0 alpha:1.0];
            } else if (daysToWorkout == 1){
                // workout is tomorrow
                cell.nextTrainingLabel.text = @"Next workout is tomorrow";
                cell.nextTrainingLabel.textColor = [UIColor colorWithRed:167.0/255.0 green:219.0/255.0 blue:216.0/255.0 alpha:1.0];
            } else {
                // workout is the other day
                cell.nextTrainingLabel.text  = [NSString stringWithFormat:@"Next workout is on %@",[dateFormatter stringFromDate:nextPlannedDate]];
                cell.nextTrainingLabel.textColor = [UIColor blackColor];
            }
        }
        // progress of workouts
        [cell.workoutsProgress setHidden:false];
        [cell.workoutsStaticSign setHidden:false];
        int totalWorkouts = (int)plan.childWorkouts.count;
        int completedWorkouts = (int)[[[self dataController] getCompletedWorkouts:plan] count];
        cell.workoutsProgress.text = [NSString stringWithFormat:@"%d of %d", completedWorkouts, totalWorkouts];
        
        // desc
        [cell.descLabel sizeToFit];
        
    } else if ([plan.status isEqualToString:@"Awaiting"]) {
        [cell.startButton setHidden:false];
        
        cell.startDateLabel.text = @"Not started yet";
        
        [cell.nextTrainingLabel setHidden:true];
        
        // progress of workouts
        [cell.workoutsProgress setHidden:true];
        [cell.workoutsStaticSign setHidden:true];
        
        // desc
        [cell.descLabel sizeToFit];
        
    } // TODO else if (plan.status isEqualToString:@"Finished"){
    
    // get variants
    /*NSArray* array = [workout.childVariants allObjects];
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
     
     }*/
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"segue: %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"startPlan"]) {
        RWPlanStartViewController *destViewController = segue.destinationViewController;
        int row = (int)((UIButton*) sender).tag;
        
        Plan* plan = [self.dataController getPlanByNum:row];
        
        destViewController.plan = plan;
    } else if ([segue.identifier isEqualToString:@"goToPlanDetails"]) {
        RWPlanDetailsViewController *destViewController = segue.destinationViewController;
        int row = (int)((RWPlanCell*) sender).tag;
        
        Plan* plan = [self.dataController getPlanByNum:row];
        
        destViewController.plan = plan;
    }
}

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue
{
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
@end
