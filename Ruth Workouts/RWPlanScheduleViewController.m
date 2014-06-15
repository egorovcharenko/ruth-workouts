//
//  RWPlanScheduleViewController.m
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 06.06.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import "RWPlanScheduleViewController.h"
#import "RWDataController.h"

#import "Workout.h"


@interface RWPlanScheduleViewController ()

@end

@implementation RWPlanScheduleViewController
@synthesize plan;
@synthesize weekdaysSelected;
@synthesize workouts;

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
    
    // only plan in the future
    self.nextTrainingDatePicker.minimumDate = [NSDate date];
    
    // title
    self.navigationItem.title = self.plan.name;
    
    // weekdays
    weekdaysSelected = (int)[plan.weekdaysSelected integerValue];
    [self updateButtons];

    // next workout date
    NSDate* nextPlannedDate = plan.nextWorkout.plannedDate;
    if (nextPlannedDate != nil){
        self.nextTrainingDatePicker.date = nextPlannedDate;
    } else {
        self.nextTrainingDatePicker.date = [NSDate date];
    }
    
    // trainings list
    workouts = [[NSMutableArray alloc] init];
    for (Workout* workout in plan.childWorkouts) {
        NSString* workoutName;
        if (workout.dateCompleted != nil) {
            workoutName = [NSString stringWithFormat:@"%02ld:(Done)%@", (long)[workout.number integerValue], workout.name];
        } else {
            workoutName = [NSString stringWithFormat:@"%02ld:%@", (long)[workout.number integerValue], workout.name];
        }
        [workouts addObject:workoutName];
    }
    // sort
    workouts = [[NSMutableArray alloc] initWithArray:[workouts sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    // show next workout
    [self.nextTrainingPicker selectRow:([plan.nextWorkout.number integerValue] - 1) inComponent:0 animated:NO];

}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return workouts.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.workouts objectAtIndex:row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rescheduleButtonClicked:(id)sender {
    // datacontroller
    RWDataController *dataController = [[RWDataController alloc] initWithAppDelegate:(RWAppDelegate*)[[UIApplication sharedApplication] delegate ]];
    
    // update plan
    plan.weekdaysSelected = [NSNumber numberWithInt:weekdaysSelected];
    int nextWorkoutNumber = (int)([self.nextTrainingPicker selectedRowInComponent:0] + 1);
    //Workout* nextWorkout = [dataController getWorkoutByNumber:plan number:nextWorkoutNumber];
    //plan.nextWorkout = nextWorkout;
    
    // complete all workouts before selected one
    for (Workout* workout in plan.childWorkouts) {
        if ([workout.number integerValue] < nextWorkoutNumber){
            // all skipped workouts should be marked as completed today
            if (workout.dateCompleted == nil){
                workout.dateCompleted = [NSDate date];
                workout.status = @"Skipped";
            }
        }
    }
    
    // set date of next workout
    //nextWorkout.plannedDate = self.nextTrainingDatePicker.date;
    
    // replan all incomplete workouts including selected
    [dataController scheduleThePlanExtended:plan startDate:self.nextTrainingDatePicker.date startWorkoutNum:nextWorkoutNumber skipFirstWorkoutWeekdayCheck:NO];
    
    // unwind to previous screen
    [self performSegueWithIdentifier:@"unwindToPlansList" sender:self];
}

- (IBAction)monClicked:(id)sender {
    weekdaysSelected ^= MondaySelected;
    [self updateButtons];}

- (IBAction)tueClicked:(id)sender {
    weekdaysSelected ^= TuesdaySelected;
    [self updateButtons];
}

- (IBAction)wedClicked:(id)sender {
    weekdaysSelected ^= WednesdaySelected;
    [self updateButtons];
}

- (IBAction)thuClicked:(id)sender {
    weekdaysSelected ^= ThursdaySelected;
    [self updateButtons];
}

- (IBAction)friClicked:(id)sender {
    weekdaysSelected ^= FridaySelected;
    [self updateButtons];
}

- (IBAction)satClicked:(id)sender {
    weekdaysSelected ^= SaturdaySelected;
    [self updateButtons];
}

- (IBAction)sunClicked:(id)sender {
    weekdaysSelected ^= SundaySelected;
    [self updateButtons];
}

- (void) updateButtons
{
    if (weekdaysSelected & MondaySelected)
        self.monButton.backgroundColor = [UIColor clearColor];
    else
        self.monButton.backgroundColor = [UIColor whiteColor];
    
    if (weekdaysSelected & TuesdaySelected)
        self.tueButton.backgroundColor = [UIColor clearColor];
    else
        self.tueButton.backgroundColor = [UIColor whiteColor];
    
    if (weekdaysSelected & WednesdaySelected)
        self.wedButton.backgroundColor = [UIColor clearColor];
    else
        self.wedButton.backgroundColor = [UIColor whiteColor];
    
    if (weekdaysSelected & ThursdaySelected)
        self.thuButton.backgroundColor = [UIColor clearColor];
    else
        self.thuButton.backgroundColor = [UIColor whiteColor];
    
    if (weekdaysSelected & FridaySelected)
        self.friButton.backgroundColor = [UIColor clearColor];
    else
        self.friButton.backgroundColor = [UIColor whiteColor];
    
    if (weekdaysSelected & SaturdaySelected)
        self.satButton.backgroundColor = [UIColor clearColor];
    else
        self.satButton.backgroundColor = [UIColor whiteColor];
    
    if (weekdaysSelected & SundaySelected)
        self.sunButton.backgroundColor = [UIColor clearColor];
    else
        self.sunButton.backgroundColor = [UIColor whiteColor];
}
@end
