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
    int count = [self.fetchResultsController.fetchedObjects count];
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

- (void)configureCell:(RWPlanCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Plan* plan = (Plan*)[self.fetchResultsController objectAtIndexPath:indexPath];
    
    // plan details
    cell.numberLabel.text = [NSString stringWithFormat:@"%d", plan.number];
    cell.nameLabel.text = plan.name;
    cell.descLabel.text = plan.desc;
    cell.startButton.tag = plan.number;
    
    
    if ([plan.status isEqualToString:@"Active"]) {
        [cell.startButton setHidden:true];
    
        // start date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
        NSDate *date = plan.startDate;
        cell.startDateLabel.text = [NSString stringWithFormat:@"Started on %@",[dateFormatter stringFromDate:date]];
        
        // next training
        [cell.nextTrainingLabel setHidden:false];
        
        
        
        cell.nextTrainingLabel = ;
        //
    } else if ([plan.status isEqualToString:@"Awaiting"]) {
        [cell.startButton setHidden:false];
    
        cell.startDateLabel.text = @"Not started yet";
        
        [cell.nextTrainingLabel setHidden:true];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"segue: %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"startPlan"]) {
        RWPlanStartViewController *destViewController = segue.destinationViewController;
        int row = ((UIButton*) sender).tag - 1;
        
        Plan* plan = (Plan*)[self.fetchResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        
        destViewController.plan = plan;
    }
}

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue
{
    [self.tableView reloadData];
}
@end
