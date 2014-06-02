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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    int count = [self.fetchResultsController.fetchedObjects count];
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
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    WorkoutVariant *variant = [self.dataController getWorkoutVariantByNumber:workout number:[workout.selectedVariantNumber integerValue]];
    
    
    // tag
    cell.checkButton.tag = indexPath.row;
    
    // workout details
    cell.workoutName.text = workout.name;
    if (workout.dateCompleted != nil){
        // completed phrase
        cell.dateLabel.text = [NSString stringWithFormat:@"Completed on %@",[dateFormatter stringFromDate:workout.dateCompleted]];
        
        WorkoutVariantEvent *event = [self.dataController getLatestWorkoutVariantEvent:variant];
        
        // time
        
        int ti = (int) [event.totalTime doubleValue];
        
        if (ti > 0.0001){
            NSInteger hours = (ti / 3600);
            NSInteger minutes = (ti / 60) % 60;
            double seconds = [event.totalTime doubleValue] - hours * 3600 - minutes * 60;
            
            if (hours > 1){
                cell.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02.2f", hours, minutes, seconds];
            } else {
                cell.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02.2f", minutes, seconds];
            }
            [cell.timeLabel setHidden:false];
        } else {
            [cell.timeLabel setHidden:true];
        }
        //len
        cell.lenLabel.textColor = [UIColor blackColor];
        cell.lenLabel.text = [NSString stringWithFormat:@"%@m", event.totalLength];
        
        // check
        [cell.checkButton setImage:[UIImage imageNamed:@"checkmark-on.png"] forState:UIControlStateNormal];
        cell.checkButton.enabled = false;
        
    } else {
        // planned text
        long daysBetweenDates = [self daysBetweenDate:[NSDate date] andDate:workout.plannedDate];
        
        if (daysBetweenDates > 2) {
            cell.dateLabel.text = [NSString stringWithFormat:@"Planned for %@",[dateFormatter stringFromDate:workout.plannedDate]];
        } else if (daysBetweenDates > 1) {
            cell.dateLabel.text = [NSString stringWithFormat:@"Training in two days"];
        } else if (daysBetweenDates > 0) {
            cell.dateLabel.text = [NSString stringWithFormat:@"Planned for tomorrow"];
        } else if (daysBetweenDates < 0) {
            cell.dateLabel.text = [NSString stringWithFormat:@"Overdue, was planned for %@",[dateFormatter stringFromDate:workout.plannedDate]];
        }
        
        // time
        [cell.timeLabel setHidden:true];
        
        // len
        cell.lenLabel.textColor = [UIColor grayColor];
        cell.lenLabel.text = [NSString stringWithFormat:@"(%@m)", variant.length];
        
        // check
        //cell.checkBox.on = false;
        cell.checkButton.enabled = true;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToCompleteTrainingScreen"]) {
        RWNewCompleteWorkoutViewController *destViewController = segue.destinationViewController;
        long row = ((UIButton*) sender).tag;
        Workout* workout = (Workout*)[self.fetchResultsController objectAtIndexPath:[NSIndexPath indexPathForRow: row inSection:0]];
        
        WorkoutVariant *variant = [self.dataController getWorkoutVariantByNumber:workout number:[workout.selectedVariantNumber integerValue]];
        
        destViewController.workoutVariant = variant;
    }
}

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue
{
    [self.tableView reloadData];
}

- (IBAction)checkButtonClicked:(id)sender forEvent:(UIEvent *)event {
    UIButton *check = (UIButton*) sender;
    [self performSegueWithIdentifier: @"goToCompleteTrainingScreen" sender: check];
    
}

@end
