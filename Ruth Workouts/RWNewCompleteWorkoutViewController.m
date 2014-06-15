//
//  RWNewCompleteWorkoutViewController.m
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 01.06.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import "RWNewCompleteWorkoutViewController.h"
#import "RWDataController.h"

#import "Workout.h"
#import "WorkoutVariant.h"
#import "WorkoutVariantEvent.h"
#import "Plan.h"

#import "RWHelper.h"

@interface RWNewCompleteWorkoutViewController ()

@end

@implementation RWNewCompleteWorkoutViewController
@synthesize returnToWorkoutsList;

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
    
    // pre-populate total len
    if ([self.workoutVariant.length integerValue] > 0) {
        self.totalDistanceText.text = [NSString stringWithFormat:@"%@", self.workoutVariant.length];
    }
    
    // pre-pop total time
    if ([self.workoutVariant.time doubleValue]> 0.01){
        NSAttributedString * timeString = [[RWHelper sharedInstance] prepareTimeString:[self.workoutVariant.time doubleValue] mainStyle:[RWHelper sharedInstance].hoursStyle thinStyle:[RWHelper sharedInstance].timeDots];
        self.totalTimeText.text = timeString.string;
    }
    
    self.totalTimeText.delegate = self;
    self.totalDistanceText.delegate = self;
    self.bestLapTimeText.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareOnFacebook:(id)sender {
}
- (NSTimeInterval)parseString:(NSString *)input
{
    NSTimeInterval ti;
    NSArray* foo = [input componentsSeparatedByString: @":"];
    if ([foo count] == 2) {
        // min + sec
        ti = [[foo objectAtIndex: 0] intValue]*60 + [[foo objectAtIndex:1] doubleValue];
        
    } else if ([foo count] == 1) {
        // sec
        ti = [[foo objectAtIndex: 0] doubleValue];
    } else if ([foo count] == 3) {
        // hours:min:sec
        ti = [[foo objectAtIndex: 0] intValue]*60*60 + [[foo objectAtIndex: 1] intValue]*60 + [[foo objectAtIndex:2] doubleValue];
    } else {
        // error
        ti = -1;
    }
    
    if (ti < 0){
        // error
    }
    return ti;
}

- (IBAction)saveClicked:(id)sender
{
    // calc times first
    double totalTime = 0.0, bestLapTime = 0.0;
    NSString *inputTotalTime =self.totalTimeText.text;
    if ([inputTotalTime length] > 0) {
        totalTime = [self parseString:inputTotalTime];
        if (totalTime < 0.01) {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:@"Please check that you enter time in format: 'hours:minutes:seconds.milliseconds', hours and minutes are optional"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
            [errorAlert show];
            return;
        }
    } else {
        totalTime = 0.0;
    }
    
    NSString *inputBestTime =self.bestLapTimeText.text;
    if ([inputBestTime length] > 0) {
        bestLapTime = [self parseString:inputBestTime];
        if (bestLapTime < 0.01) {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:@"Please enter time in format: 'hours:minutes:seconds.milliseconds' (hours and minutes are optional)"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
            [errorAlert show];
            return;
        }
    } else {
        bestLapTime = 0.0;
    }

    // check total len first
    int totalDistance = 0;
    
    // total len
    if (self.totalDistanceText.text.length > 0){
        totalDistance = [self.totalDistanceText.text intValue];
    }
    
    if ((totalDistance == 0) && (totalTime < 0.001)) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Please enter at least either total time or total length"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errorAlert show];
        return;
    }
    
    // create event
    RWDataController *dataController = [[RWDataController alloc] initWithAppDelegate:(RWAppDelegate*)[[UIApplication sharedApplication] delegate ]];
    WorkoutVariantEvent *event = [NSEntityDescription insertNewObjectForEntityForName:@"WorkoutVariantEvent" inManagedObjectContext:dataController.context];
    
    event.comment = self.commentTextView.text;
        
    // total len
    event.totalLength = [NSNumber numberWithInt:totalDistance];
    
    // total time
    event.totalTime = [NSNumber numberWithDouble:totalTime];
    
    // lap time
    event.bestLapTime = [NSNumber numberWithDouble:bestLapTime];
    
    // date completed
    event.date = [NSDate date];
    
    // parent
    event.parentVariant = self.workoutVariant;
    
    // set completed flags on workout
    self.workoutVariant.parentWorkout.dateCompleted = [[NSDate alloc] init];
    self.workoutVariant.parentWorkout.status = @"Completed";
    
    // update plan's next workout?
    Plan* plan = self.workoutVariant.parentWorkout.parentPlan;
    if (plan != nil) {
        if ([plan.number integerValue] != 0) {
            plan.nextWorkout = [dataController getNextUncompletedWorkout:plan];
        }
    }
    // ask to reschedule all others workouts? or auto?
    
    // save data
    [dataController saveData];
    
    // unwind to previous screen
    if (returnToWorkoutsList) {
        [self performSegueWithIdentifier:@"unwindToListOfWorkouts" sender:self];
    } else {
        [self performSegueWithIdentifier:@"unwindToPlanDetails" sender:self];
    }
}

- (IBAction)shareOnTwitter:(id)sender {
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
