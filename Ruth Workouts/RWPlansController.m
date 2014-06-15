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
#include "Category.h"

#import "RWHelper.h"

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
    int count = (int)[self.fetchResultsController.fetchedObjects count];
    return count;
}

- (void)initFetchController
{
    // init fetch controller
    self.fetchResultsController = [self.dataController getAllCategories];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Category *category = [[self.fetchResultsController fetchedObjects] objectAtIndex:section];
    int count = (int)category.childPlans.count;
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

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

- (int) daysDiffFrom:(NSDate *) firstDate to:(NSDate*)secondDate
{
    return (int)[self daysBetweenDate:secondDate andDate:firstDate];
}

- (Category *)getCategory:(NSIndexPath *)indexPath
{
    Category *category = [[self.fetchResultsController fetchedObjects] objectAtIndex:indexPath.section];
    return category;
}

- (void)configureCell:(RWPlanCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Plan* plan = [self getPlan:indexPath];
    
    // plan details
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)[plan.displayNumber integerValue]];
    cell.nameLabel.text = plan.name;
    cell.nameLabel.textColor = [UIColor blackColor];
    
    cell.descLabel.text = plan.desc;
    
    // set tags
    cell.startButton.tag = [plan.number integerValue];
    cell.tag = [plan.number integerValue];
    
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
            cell.nextTrainingLabel.textColor = [RWHelper sharedInstance].cleanPoundwater;
            // highlight the plan name
            cell.nameLabel.textColor = [RWHelper sharedInstance].cleanPoundwater;
        } else {
            NSDate* nextPlannedDate = plan.nextWorkout.plannedDate;
            [cell.nextTrainingLabel setHidden:false];
            int daysToWorkout = [self daysDiffFrom:plan.nextWorkout.plannedDate to:[NSDate date]];
            cell.nextTrainingLabel.textColor = [UIColor blackColor];
            if (daysToWorkout == 0){
                // workout is today
                cell.nextTrainingLabel.text = @"Next workout is today!";
                cell.nextTrainingLabel.textColor = [RWHelper sharedInstance].unrealFoodPills;
            } else if (daysToWorkout == 1){
                // workout is tomorrow
                cell.nextTrainingLabel.text = @"Next workout is tomorrow";
                cell.nextTrainingLabel.textColor = [RWHelper sharedInstance].aoi;
            } else {
                // workout is the other day
                cell.nextTrainingLabel.text  = [NSString stringWithFormat:@"Next workout is on %@",[dateFormatter stringFromDate:nextPlannedDate]];
                cell.nextTrainingLabel.textColor = [UIColor blackColor];
            }
            
            // highlight the plan name
            cell.nameLabel.textColor = [RWHelper sharedInstance].unrealFoodPills;
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

- (Plan *)getPlan:(NSIndexPath *)indexPath {
    Category* category = [self getCategory:indexPath];
    Plan* plan = [self.dataController getPlanFromCategory:category planNum:(int)(indexPath.row)];
    return plan;
}

- (NSIndexPath *)getIndexPath:(id)sender {
    //int row = (int)((UIButton*) sender).tag;
    
    UIView *view = sender;
    while (view != nil && ![view isKindOfClass:[UITableViewCell class]]) {
        view = [view superview];
    }
    UITableViewCell *cell = (UITableViewCell *) view;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    return indexPath;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"startPlan"]) {
        RWPlanStartViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath;
        indexPath = [self getIndexPath:sender];
        
        Plan *plan;
        plan = [self getPlan:indexPath];
        
        destViewController.plan = plan;
    } else if ([segue.identifier isEqualToString:@"goToPlanDetails"]) {
        RWPlanDetailsViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath;
        indexPath = [self getIndexPath:sender];
        
        Plan *plan;
        plan = [self getPlan:indexPath];
        
        destViewController.plan = plan;
    }
}

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue
{
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Category *category = [[self.fetchResultsController fetchedObjects] objectAtIndex:section];
    return category.name;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Plan* plan = [self getPlan:indexPath];
    int commentLen = 0;
    
    if (plan.desc.length > 0){
        UIFont *detailsFont = [UIFont systemFontOfSize:15];
        CGRect rect = [self sizeOfLabel:plan.desc maxLabelWidth:280 font:detailsFont];
        commentLen = rect.size.height + 82;
    }
    
    return MAX(commentLen, 82) + 15;
}

@end
