//
//  RWPlanDetailsViewController.m
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 26.05.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import "RWPlanDetailsViewController.h"
#import "RWPlanWorkoutCell.h"

#import "Workout.h"
#import "WorkoutVariant.h"
#import "WorkoutVariantEvent.h"
#import "RWNewCompleteWorkoutViewController.h"
#import "RWWorkoutDetailsController.h"
#import "RWPlanScheduleViewController.h"

#import "RWDataController.h"

#import "RWHelper.h"

@interface RWPlanDetailsViewController ()

@end

@implementation RWPlanDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshTopPanel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) refreshTopPanel
{
    // start date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d LLL"];
    
    self.startDateLabel.text = [formatter stringFromDate:self.plan.startDate];
    
    // end date
    self.endDateLabel.text = [formatter stringFromDate:[self.dataController getPlannedEndDate:self.plan]];
    
    // progress bar and text
    long completedWoutsCount = [self.dataController getCompletedWorkoutsNumber:self.plan];
    long totalWoutsCount = self.plan.childWorkouts.count;
    
    if (totalWoutsCount > 0){
        double percent = ((double)completedWoutsCount / (double)totalWoutsCount) * 100.0;
        
        NSString* text = [NSString stringWithFormat:@"%.0f%% (%ld of %ld)", percent, completedWoutsCount, totalWoutsCount];
        self.progressLabel.text = text;
        
        self.progressBar.progress = percent / 100.0;
    }
    
    // title
    self.navigationItem.title = self.plan.name;
}

- (void) refresh
{
    [self.tableView reloadData];
    [self refreshTopPanel];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)initFetchController
{
    // init fetch controller
    self.fetchResultsController = [self.dataController getWorkoutsOfAPlan:self.plan];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = (int)[self.fetchResultsController.fetchedObjects count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWPlanWorkoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
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


- (void)configureCell:(RWPlanWorkoutCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Workout* workout = (Workout*)[self.fetchResultsController objectAtIndexPath:indexPath];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd LLL"];
    WorkoutVariant *variant = [self.dataController getWorkoutVariantByNumber:workout number:(int)[workout.selectedVariantNumber integerValue]];
    
    
    // tag
    cell.checkButton.tag = indexPath.row;
    cell.tag = indexPath.row;
    
    // workout details
    cell.workoutName.text = workout.name;
    if (workout.dateCompleted != nil){
        // completed phrase
        cell.dateLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:workout.dateCompleted]];
        cell.dateLabel.textColor = [UIColor darkGrayColor];
        
        WorkoutVariantEvent *event = [self.dataController getLatestWorkoutVariantEvent:variant];
        
        // best time label
        int ti = (int) [event.bestLapTime doubleValue];
        
        if (ti > 0.001){
            NSMutableAttributedString* time = [[RWHelper sharedInstance] prepareTimeString:ti mainStyle:[RWHelper sharedInstance].smallGrayLengthStyle thinStyle:[RWHelper sharedInstance].smallGrayMetersStyle];
            
            NSMutableArray *pairs = [[NSMutableArray alloc] init];
            RWStringStylePair* pair = [[RWStringStylePair alloc] init];
            pair.text = @"Best lap: ";
            pair.style = [RWHelper sharedInstance].smallGrayMetersStyle;
            [pairs addObject:pair];
            NSMutableAttributedString* bestLapString = [RWHelper prepareAttributedString:pairs];
            
            [bestLapString appendAttributedString:time];
            
            cell.timeLabel.attributedText = bestLapString;
            cell.timeLabel.textAlignment = NSTextAlignmentLeft;
            [cell.timeLabel setHidden:false];
        } else {
            [cell.timeLabel setHidden:true];
        }
        
        // len or time label
        NSMutableAttributedString *resultingLenAndTimeAttrString;
        resultingLenAndTimeAttrString = [[RWHelper sharedInstance] prepareLenAndTimeAttributedString: (int)[event.totalLength integerValue] time:[event.totalTime doubleValue] grayStyle:false];
        
        cell.lenLabel.attributedText = resultingLenAndTimeAttrString;
        cell.lenLabel.textAlignment = NSTextAlignmentRight;
        
        // check
        [cell.checkButton setImage:[UIImage imageNamed:@"checkmark-on.png"] forState:UIControlStateNormal];
        [cell.checkButton setImage:[UIImage imageNamed:@"checkmark-on.png"] forState:UIControlStateDisabled];
        [cell.checkButton setImageEdgeInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
        //cell.checkButton.enabled = false;
        [cell.checkButton setHidden:NO];
        
    } else {
        // planned text
        if (workout.plannedDate != nil){
            long daysBetweenDates = [self daysBetweenDate:[NSDate date] andDate:workout.plannedDate];
            
            if (daysBetweenDates == 1) {
                cell.dateLabel.text = [NSString stringWithFormat:@"tomorrow"];
            } else if (daysBetweenDates == 0) {
                cell.dateLabel.text = @"Today";
            } else if (daysBetweenDates < 0) {
                cell.dateLabel.text = @"Overdue";
            } else {
                cell.dateLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:workout.plannedDate]];
            }
        } else {
            cell.dateLabel.text = @"";
        }
        // time
        [cell.timeLabel setHidden:true];
        
        // len or time
        NSMutableAttributedString *resultingLenAndTimeAttrString;
        resultingLenAndTimeAttrString = [[RWHelper sharedInstance] prepareLenAndTimeAttributedString:(int)[variant.length integerValue] time:[variant.time doubleValue] grayStyle:true];
        
        cell.lenLabel.textColor = [UIColor grayColor];
        cell.lenLabel.attributedText = resultingLenAndTimeAttrString;
        cell.lenLabel.textAlignment = NSTextAlignmentRight;
        
        // check
        [cell.checkButton setImage:[UIImage imageNamed:@"checkmark-off-grey.png"] forState:UIControlStateDisabled];
        [cell.checkButton setImage:[UIImage imageNamed:@"checkmark-off.png"] forState:UIControlStateNormal];
        [cell.checkButton setImageEdgeInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
        // disable check if it's not the next training
        if ([self.plan.nextWorkout.number isEqualToNumber:workout.number]){
            cell.checkButton.enabled = true;
            [cell.checkButton setHidden:NO];
            cell.dateLabel.textColor = [RWHelper sharedInstance].giantGoldfish;
        } else {
            cell.checkButton.enabled = false;
            //[cell.checkButton setHidden:YES];
            cell.dateLabel.textColor = [UIColor darkGrayColor];
        }        
    }
}

- (WorkoutVariant*) workoutVariantBySender: (id)sender
{
    long row = ((UIView*) sender).tag;
    Workout* workout = (Workout*)[self.fetchResultsController objectAtIndexPath:[NSIndexPath indexPathForRow: row inSection:0]];
    WorkoutVariant *variant = [self.dataController getWorkoutVariantByNumber:workout number:(int)[workout.selectedVariantNumber integerValue]];
    return variant;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToCompleteTrainingScreen"]) {
        RWNewCompleteWorkoutViewController *destViewController = segue.destinationViewController;
        destViewController.workoutVariant = [self workoutVariantBySender:sender];
    } else if ([[segue identifier] isEqualToString:@"workoutDetailsFromPlan"]) {
        RWWorkoutDetailsController *destViewController = segue.destinationViewController;
        destViewController.variant= [self workoutVariantBySender:sender];
        if (destViewController.variant.parentWorkout.dateCompleted != nil) {
            destViewController.canComplete = false;
        } else {
            destViewController.canComplete = true;
        }
    } else if ([[segue identifier] isEqualToString:@"scheduleSegue"]) {
        RWPlanScheduleViewController *destViewController = segue.destinationViewController;
        destViewController.plan = self.plan;
    }
}

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue
{
    [self refresh];
}

- (IBAction)checkButtonClicked:(id)sender forEvent:(UIEvent *)event {
    UIButton *check = (UIButton*) sender;
    [self performSegueWithIdentifier: @"goToCompleteTrainingScreen" sender: check];
}

- (IBAction)scheduleClicked:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Plan next training for tomorrow", @"Repeat last training tomorrow", @"Advanced scheduling", nil];
    [actionSheet showInView:self.view];
}

- (NSDate *)getTomorrow
{
    return [self addDaysToNow:1];
}

- (NSDate *)getAfterTomorrow
{
    return [self addDaysToNow:2];
}

- (NSDate *)addDaysToNow:(int)daysToAdd
{
    // move next training to closest date
    // get tomorrow's date
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = daysToAdd;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *tomorrow = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    return tomorrow;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"The %ld button was tapped.", (long)buttonIndex);
    if (buttonIndex == 0)
    {
        // plan next training for tomorrow
        if (self.plan.nextWorkout == nil){
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Plan is finished"
                                                                 message:@"All workouts of this plan are completed, so there's no next workout."
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
            [errorAlert show];
            return;
        }
        NSDate *tomorrow = [self getTomorrow];
        
        NSUInteger adjustedWeekdayOrdinal;
        adjustedWeekdayOrdinal = [RWHelper getWeekday:tomorrow];
        if ((1 << (adjustedWeekdayOrdinal-1)) & [self.plan.weekdaysSelected integerValue]){
            // date match - ok, move replan without options
            [self.dataController scheduleThePlanExtended:self.plan startDate:tomorrow startWorkoutNum:(int)[self.plan.nextWorkout.number integerValue] skipFirstWorkoutWeekdayCheck:NO];
            [self refresh];
        } else {
            // if no - show dialog
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Weekdays don't match"
                                                                 message:@"Tomorrow doesn't fall on your training weekdays of choice. We can replan anyway or show additional options."
                                                                delegate:self
                                                       cancelButtonTitle:@"Cancel"
                                                       otherButtonTitles:@"Replan anyway", @"Show more options", nil];
            [errorAlert show];
        }
    } else if (buttonIndex == 1) {
        // repeat for tomorrow
        long nextTrainingNum;
        if (self.plan.nextWorkout == nil){
            nextTrainingNum = self.plan.childWorkouts.count;
        } else {
            nextTrainingNum = [self.plan.nextWorkout.number integerValue];
            if (nextTrainingNum > 1)
                nextTrainingNum --;
        }
        
        NSDate *tomorrow = [self getTomorrow];
        [self.dataController scheduleThePlanExtended:self.plan startDate:tomorrow startWorkoutNum:(int)nextTrainingNum skipFirstWorkoutWeekdayCheck:NO];
        [self refresh];
    } /*else if (buttonIndex == 2) {
        // repeat for day after tomorrow
        long nextTrainingNum = [self.plan.nextWorkout.number integerValue];
        if (nextTrainingNum > 1)
            nextTrainingNum --;
        NSDate *tomorrow = [self getAfterTomorrow];
        [self.dataController scheduleThePlanExtended:self.plan startDate:tomorrow startWorkoutNum:nextTrainingNum skipFirstWorkoutWeekdayCheck:NO];
    } */else if (buttonIndex == 2) {
        // advanced scheduling
        [self performSegueWithIdentifier:@"scheduleSegue" sender:self];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        // replan with skipping
        NSDate *tomorrow = [self getTomorrow];
        [self.dataController scheduleThePlanExtended:self.plan startDate:tomorrow startWorkoutNum:(int)[self.plan.nextWorkout.number integerValue] skipFirstWorkoutWeekdayCheck:YES];
        [self refresh];
    } else if(buttonIndex == 2) {
        // show advanced
        [self performSegueWithIdentifier:@"scheduleSegue" sender:self];
    }
}

@end
