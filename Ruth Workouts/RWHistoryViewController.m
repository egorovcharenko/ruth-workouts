//
//  RWHistoryViewController.m
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 13.06.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import "RWHistoryViewController.h"

#import "RWEventCell.h"
#import "RWHelper.h"

#import "WorkoutVariantEvent.h"
#import "WorkoutVariant.h"
#import "Workout.h"
#import "Plan.h"
#import "Category.h"

@interface RWHistoryViewController ()

@end

@implementation RWHistoryViewController

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
    self.fetchResultsController = [self.dataController getAllEvents];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchResultsController fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(RWEventCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    WorkoutVariantEvent* event = [self.fetchResultsController objectAtIndexPath:indexPath];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd LLL YYYY"];
    
    // date
    cell.dateLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:event.date]];
    
    // activity
    cell.activityLabel.text = event.parentVariant.parentWorkout.activity;
    cell.activityLabel.textColor = [UIColor whiteColor];
    cell.activityLabel.backgroundColor = [RWHelper sharedInstance].aoi;
    
    // plan and workout
    Plan* plan = event.parentVariant.parentWorkout.parentPlan;
    
    NSMutableArray *pairs = [[NSMutableArray alloc] init];
    
    RWStringStylePair* pair = [[RWStringStylePair alloc] init];
    pair.text = [NSString stringWithFormat:@"%@ / ", plan.name];
    pair.style = [RWHelper sharedInstance].aoiThickStyle;
    [pairs addObject:pair];
    
    pair = [[RWStringStylePair alloc] init];
    pair.text = event.parentVariant.parentWorkout.name;
    pair.style = [RWHelper sharedInstance].aoiThinStyle;
    [pairs addObject:pair];
    
    cell.planAndWorkoutLabel.attributedText = [RWHelper prepareAttributedString:pairs];
    // add some soft shadow
    //cell.planAndWorkoutLabel.shadowColor = [UIColor lightGrayColor];
    //cell.planAndWorkoutLabel.shadowOffset = CGSizeMake(0.0, 0.0);
    //cell.planAndWorkoutLabel.layer.shadowRadius = 3;
    //cell.planAndWorkoutLabel.layer.shadowOpacity = 0.001;
    //cell.planAndWorkoutLabel.layer.masksToBounds = false;
    
    // best lap
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
        
        cell.bestLapLabel.attributedText = bestLapString;
        cell.bestLapLabel.textAlignment = NSTextAlignmentRight;
        [cell.bestLapLabel setHidden:false];
    } else {
        [cell.bestLapLabel setHidden:true];
    }
    
    // total time and lenght
    NSMutableAttributedString *resultingLenAndTimeAttrString;
    resultingLenAndTimeAttrString = [[RWHelper sharedInstance] prepareLenAndTimeAttributedString:(int)[event.totalLength integerValue] time:[event.totalTime doubleValue] grayStyle:false];
    
    cell.lenAndTimeLabel.attributedText = resultingLenAndTimeAttrString;
    cell.lenAndTimeLabel.textAlignment = NSTextAlignmentRight;
    
    // comment
    cell.commentLabel.text = event.comment;
    cell.commentLabel.textColor = [UIColor darkGrayColor];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // TODO change this hack
    [self initFetchController];
    
    [self.tableView reloadData];

    if ([[self.fetchResultsController fetchedObjects] count] == 0){
        // if no data is present - show empty message
        self.noDataRect = [[UIView alloc]init];
        self.noDataRect.frame = CGRectMake(0,0,100,600);//set the frame
        self.noDataRect.backgroundColor = [RWHelper sharedInstance].beachStorm;
        
        UILabel* label = [[UILabel alloc]init];
        label.text = @"No history yet. Complete at least one workout for data to be shown here";
        label.textColor = [UIColor darkGrayColor];
        [self.noDataRect addSubview:label];
        label.numberOfLines = 0;
        label.preferredMaxLayoutWidth = 100;
        label.frame = CGRectMake(10,10,300,400);
        label.textAlignment = NSTextAlignmentCenter;
        
        self.tableView.tableHeaderView = self.noDataRect;
        self.tableView.userInteractionEnabled = false;
        return;
    } else {
        self.tableView.tableHeaderView = nil;
        self.tableView.userInteractionEnabled = true;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkoutVariantEvent* event = [self.fetchResultsController objectAtIndexPath:indexPath];
    int commentLen = 0;
    int trainingLen = 0;
    
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 149, 30);
    label.numberOfLines = 0;
    label.preferredMaxLayoutWidth = 149;
    Plan* plan = event.parentVariant.parentWorkout.parentPlan;
    NSMutableArray *pairs = [[NSMutableArray alloc] init];
    RWStringStylePair* pair = [[RWStringStylePair alloc] init];
    pair.text = [NSString stringWithFormat:@"%@ / ", plan.name];
    pair.style = [RWHelper sharedInstance].aoiThickStyle;
    [pairs addObject:pair];
    pair = [[RWStringStylePair alloc] init];
    pair.text = event.parentVariant.parentWorkout.name;
    pair.style = [RWHelper sharedInstance].aoiThinStyle;
    [pairs addObject:pair];
    
    label.attributedText = [RWHelper prepareAttributedString:pairs];
    [label sizeToFit];
    
    trainingLen = label.frame.size.height;
    
    if (event.comment.length > 0){
        UIFont *detailsFont = [UIFont systemFontOfSize:14];
        CGRect rect = [self sizeOfLabel:event.comment maxLabelWidth:300 font:detailsFont];
        commentLen = rect.size.height;
        return MAX(trainingLen + 48 + 10 + commentLen + 15, 100);
    } else {
        return MAX(trainingLen + 48 + 15, 100);
        
    }
    
}

@end
