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
    
    [self updateButtons];
}

- (void) updateButtons
{
    if (plan.weekdaysSelected & MondaySelected)
        self.monButton.backgroundColor = [UIColor clearColor];
    else
        self.monButton.backgroundColor = [UIColor whiteColor];
    
    if (plan.weekdaysSelected & TuesdaySelected)
        self.tueButton.backgroundColor = [UIColor clearColor];
    else
        self.tueButton.backgroundColor = [UIColor whiteColor];
    
    if (plan.weekdaysSelected & WednesdaySelected)
        self.wedButton.backgroundColor = [UIColor clearColor];
    else
        self.wedButton.backgroundColor = [UIColor whiteColor];

    if (plan.weekdaysSelected & ThursdaySelected)
        self.thuButton.backgroundColor = [UIColor clearColor];
    else
        self.thuButton.backgroundColor = [UIColor whiteColor];

    if (plan.weekdaysSelected & FridaySelected)
        self.friButton.backgroundColor = [UIColor clearColor];
    else
        self.friButton.backgroundColor = [UIColor whiteColor];

    if (plan.weekdaysSelected & SaturdaySelected)
        self.satButton.backgroundColor = [UIColor clearColor];
    else
        self.satButton.backgroundColor = [UIColor whiteColor];

    if (plan.weekdaysSelected & SundaySelected)
        self.sunButton.backgroundColor = [UIColor clearColor];
    else
        self.sunButton.backgroundColor = [UIColor whiteColor];
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
    plan.weekdaysSelected ^= MondaySelected;
    [self updateButtons];
}

- (IBAction)tueClicked:(id)sender {
    plan.weekdaysSelected ^= TuesdaySelected;
    [self updateButtons];
}

- (IBAction)wedClicked:(id)sender {
    plan.weekdaysSelected ^= WednesdaySelected;
    [self updateButtons];
}

- (IBAction)thuClicked:(id)sender {
    plan.weekdaysSelected ^= ThursdaySelected;
    [self updateButtons];
}

- (IBAction)friClicked:(id)sender {
    plan.weekdaysSelected ^= FridaySelected;
    [self updateButtons];
}

- (IBAction)satClicked:(id)sender {
    plan.weekdaysSelected ^= SaturdaySelected;
    [self updateButtons];
}

- (IBAction)sunClicked:(id)sender {
    plan.weekdaysSelected ^= SundaySelected;
    [self updateButtons];
}

- (IBAction)createPlanClicked:(id)sender {
    plan.startDate = self.datePicker.date;
    [[[RWDataController alloc] initWithAppDelegate:(RWAppDelegate*)[[UIApplication sharedApplication] delegate ]]scheduleThePlan:plan];
    [self performSegueWithIdentifier:@"unwindToPlansList" sender:self];
}
@end
