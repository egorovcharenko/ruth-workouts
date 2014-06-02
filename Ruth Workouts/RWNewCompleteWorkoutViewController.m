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

@interface RWNewCompleteWorkoutViewController ()

@end

@implementation RWNewCompleteWorkoutViewController

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
    self.totalDistanceText.text = [NSString stringWithFormat:@"%@", self.workoutVariant.length];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    double totalTime, bestLapTime = 0.0;
    NSString *inputTotalTime =self.totalTimeText.text;
    if ([inputTotalTime length] > 0) {
        double totalTime = [self parseString:inputTotalTime];
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
        totalTime = 0;
    }
    
    NSString *inputBestTime =self.bestLapTimeText.text;
    if ([inputBestTime length] > 0) {
        double bestLapTime = [self parseString:inputBestTime];
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
        bestLapTime = 0;
    }

    // create event
    RWDataController *dataController = [[RWDataController alloc] initWithAppDelegate:(RWAppDelegate*)[[UIApplication sharedApplication] delegate ]];
    WorkoutVariantEvent *event = [NSEntityDescription insertNewObjectForEntityForName:@"WorkoutVariantEvent" inManagedObjectContext:dataController.context];
    
    event.comment = @""; // TODO
    
    // total len
    event.totalLength = [NSNumber numberWithInt:[self.totalDistanceText.text intValue]];
    
    // total time
    event.totalTime = [NSNumber numberWithDouble:totalTime];
    
    // lap time
    event.totalTime = [NSNumber numberWithDouble:bestLapTime];
    
    // parent
    event.parentVariant = self.workoutVariant;
    
    // set completed flags on workout
    self.workoutVariant.parentWorkout.dateCompleted = [[NSDate alloc] init];
    self.workoutVariant.parentWorkout.status = @"Completed";
    
    // update plan?
    
    // reschedule all others workouts?
    
    // save data
    [dataController saveData];
    
    // unwind to previous screen
    [self performSegueWithIdentifier:@"unwindToPlanDetails" sender:self];
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
