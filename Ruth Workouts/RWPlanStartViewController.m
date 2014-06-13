//
//  RWPlanStartViewController.m
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 18.05.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import "RWPlanStartViewController.h"

#import "RWDataController.h"

@interface RWPlanStartViewController ()

@end

@implementation RWPlanStartViewController
@synthesize plan;

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
    
    self.navigationItem.title = plan.name;
    plan.startDate = [[NSDate alloc] init];
    self.datePicker.minimumDate = [NSDate date];
    
    [self updateButtons];
}

- (void) updateButtons
{
    if ([plan.weekdaysSelected integerValue] & MondaySelected){
        self.monButton.backgroundColor = [UIColor clearColor];
        self.monButton.tintColor = [[[[UIApplication sharedApplication] delegate] window] tintColor];
    } else {
        self.monButton.backgroundColor = [UIColor whiteColor];
        self.monButton.tintColor = [UIColor grayColor];
    }
    if ([plan.weekdaysSelected integerValue] & TuesdaySelected){
        self.tueButton.backgroundColor = [UIColor clearColor];
        self.tueButton.tintColor = [[[[UIApplication sharedApplication] delegate] window] tintColor];
    } else {
        self.tueButton.backgroundColor = [UIColor whiteColor];
        self.tueButton.tintColor = [UIColor grayColor];
    }
    if ([plan.weekdaysSelected integerValue] & WednesdaySelected){
        self.wedButton.backgroundColor = [UIColor clearColor];
        self.wedButton.tintColor = [[[[UIApplication sharedApplication] delegate] window] tintColor];
    } else {
        self.wedButton.backgroundColor = [UIColor whiteColor];
        self.wedButton.tintColor = [UIColor grayColor];
    }
    if ([plan.weekdaysSelected integerValue] & ThursdaySelected){
        self.thuButton.backgroundColor = [UIColor clearColor];
        self.thuButton.tintColor = [[[[UIApplication sharedApplication] delegate] window] tintColor];
    } else {
        self.thuButton.backgroundColor = [UIColor whiteColor];
        self.thuButton.tintColor = [UIColor grayColor];
    }
    if ([plan.weekdaysSelected integerValue] & FridaySelected){
        self.friButton.backgroundColor = [UIColor clearColor];
        self.friButton.tintColor = [[[[UIApplication sharedApplication] delegate] window] tintColor];
    } else {
        self.friButton.backgroundColor = [UIColor whiteColor];
        self.friButton.tintColor = [UIColor grayColor];
    }
    if ([plan.weekdaysSelected integerValue] & SaturdaySelected){
        self.satButton.backgroundColor = [UIColor clearColor];
        self.satButton.tintColor = [[[[UIApplication sharedApplication] delegate] window] tintColor];
    } else {
        self.satButton.backgroundColor = [UIColor whiteColor];
        self.satButton.tintColor = [UIColor grayColor];
    }
    if ([plan.weekdaysSelected integerValue] & SundaySelected){
        self.sunButton.backgroundColor = [UIColor clearColor];
        self.sunButton.tintColor = [[[[UIApplication sharedApplication] delegate] window] tintColor];
    } else {
        self.sunButton.backgroundColor = [UIColor whiteColor];
        self.sunButton.tintColor = [UIColor grayColor];
    }
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

- (IBAction)newStartDateSelected:(id)sender forEvent:(UIEvent *)event {
}

- (IBAction)monClicked:(id)sender {
    plan.weekdaysSelected = [NSNumber numberWithInt:(int)([plan.weekdaysSelected integerValue] ^ MondaySelected)];
    [self updateButtons];
}

- (IBAction)tueClicked:(id)sender {
    plan.weekdaysSelected = [NSNumber numberWithInt:(int)([plan.weekdaysSelected integerValue] ^ TuesdaySelected)];
    [self updateButtons];
}

- (IBAction)wedClicked:(id)sender {
    plan.weekdaysSelected = [NSNumber numberWithInt:(int)([plan.weekdaysSelected integerValue] ^ WednesdaySelected)];
    [self updateButtons];
}

- (IBAction)thuClicked:(id)sender {
    plan.weekdaysSelected = [NSNumber numberWithInt:(int)([plan.weekdaysSelected integerValue] ^ ThursdaySelected)];
    [self updateButtons];
}

- (IBAction)friClicked:(id)sender {
    plan.weekdaysSelected = [NSNumber numberWithInt:(int)([plan.weekdaysSelected integerValue] ^ FridaySelected)];
    [self updateButtons];
}

- (IBAction)satClicked:(id)sender {
    plan.weekdaysSelected = [NSNumber numberWithInt:(int)([plan.weekdaysSelected integerValue] ^ SaturdaySelected)];
    [self updateButtons];
}

- (IBAction)sunClicked:(id)sender {
    plan.weekdaysSelected = [NSNumber numberWithInt:(int)([plan.weekdaysSelected integerValue] ^ SundaySelected)];
    [self updateButtons];
}

- (IBAction)createPlanClicked:(id)sender {
    plan.startDate = self.datePicker.date;
    [[[RWDataController alloc] initWithAppDelegate:(RWAppDelegate*)[[UIApplication sharedApplication] delegate ]]scheduleThePlan:plan];
    [self performSegueWithIdentifier:@"unwindToPlansList" sender:self];
}
@end
