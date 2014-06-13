//
//  RWWorkoutDetailsController.m
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 01.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import "RWWorkoutDetailsController.h"

#import "Section.h"
#import "SectionActivity.h"
#import "WorkoutVariant.h"
#import "RWCompleteWorkoutViewController.h"
#import "RWNewCompleteWorkoutViewController.h"
#import "RWHelper.h"

#import "RWActivityCell.h"

#import <QuartzCore/QuartzCore.h>

@interface RWWorkoutDetailsController ()

@end

@implementation RWWorkoutDetailsController

@synthesize variant;

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
    
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [variant.childSections count];
}

- (void)initFetchController
{
    // init fetch controller
    self.fetchResultsController = [self.dataController getAllDefaultWorkouts];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionNumber
{
    Section *section = [self getSection:sectionNumber];
    return [section.childActivities count];
}

- (Section*) getSection:(NSInteger)sectionNumber
{
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]];
    
    NSArray *sortedSections = [[variant.childSections allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    
    return sortedSections[sectionNumber];
}

- (SectionActivity *)getSectionActivity:(NSIndexPath *)indexPath
{
    Section *section = [self getSection:indexPath.section];
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]];
    //int count = [section.childActivities count];
    NSArray *sortedActivities = [[section.childActivities allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    
    return sortedActivities [indexPath.row];
}

- (void)configureCell:(RWActivityCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    SectionActivity *activity;
    activity = [self getSectionActivity:indexPath];
    
    if ([activity.lenDetails length] == 0)
        activity.lenDetails = @" ";
    
    // details label
    cell.detailsLabel.text =  activity.details;
    
    // len details label
    cell.lenDetailsLabel.text = activity.lenDetails;
    CGRect rect = [self sizeOfLabel:activity.lenDetails maxLabelWidth:300 font:nil];
    cell.lenDetailsHeightConstraint.constant = rect.size.height;
    
    // swim button
    [cell.activityNameButton setTitle:activity.name forState:UIControlStateNormal];
    rect = [self sizeOfLabel:activity.name maxLabelWidth:999 font:nil];
    cell.activityNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cell.activityNameButton sizeToFit];
    
    //cell.detailsButtonWidthConstraint.constant = rect.size.width + 26;
    
    // length button
    NSMutableAttributedString *attributedText;
    
    if ([activity.unit isEqualToString:@"meters"]){
        // show length
        NSString *firstPart = [NSString stringWithFormat:@"%ld", (long)[activity.lenMultiplier integerValue]];
        NSString *crossPart = [NSString stringWithFormat:@" x "];
        NSString *secondPart = [NSString stringWithFormat:@"%ld", (long)[activity.len integerValue]];
        NSString *unitsPart = @"m";
        if ([activity.lenMultiplier integerValue] == 1){
            firstPart = @"";
            crossPart = @"";
        }
        NSString *text = [NSString stringWithFormat:@"%@%@%@%@",
                          firstPart,
                          crossPart,
                          secondPart,
                          unitsPart];
        
        // general attributes for the entire text
        UIColor *giantGoldfish = [UIColor colorWithRed:243.0/255.0 green:134.0/255.0 blue:48.0/255.0 alpha:1.0];
        NSDictionary *attribs = @{NSForegroundColorAttributeName:giantGoldfish,
                                  NSFontAttributeName: cell.lenButton.titleLabel.font};
        attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        
        UIFont *lightFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:cell.lenButton.titleLabel.font.pointSize];
        
        NSRange crossRange = [text rangeOfString:crossPart];
        [attributedText setAttributes:@{NSFontAttributeName:lightFont, NSBaselineOffsetAttributeName:@2, NSForegroundColorAttributeName:giantGoldfish} range:crossRange];
        
        NSRange thirdRange = [text rangeOfString:unitsPart];
        [attributedText setAttributes:@{NSFontAttributeName:lightFont, NSForegroundColorAttributeName:giantGoldfish} range:thirdRange];
        
    } else if ([activity.unit isEqualToString:@"seconds"]){
        attributedText = [[RWHelper sharedInstance] prepareTimeString:[activity.len doubleValue] mainStyle:[RWHelper sharedInstance].hoursStyle thinStyle:[RWHelper sharedInstance].timeDots];
    }
    
    [cell.lenButton setAttributedTitle:attributedText forState:UIControlStateNormal];
    cell.lenButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionNumber
{
    Section *section = [self getSection:sectionNumber];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    
    //allocate the view if it doesn't exist yet
    UIView* headerManualView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    
    // add gradient on the background
    [headerManualView setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:228.0/255.0 blue:204.0/255.0 alpha:1.0]];
    
    // font
    UIFont *yourFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    
    // section name
    UILabel *sectionName = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 30)];
    sectionName.text = section.name;
    sectionName.backgroundColor = [UIColor clearColor];
    sectionName.textColor = [UIColor blackColor];
    sectionName.textAlignment = NSTextAlignmentLeft;
    sectionName.font = yourFont;
    [headerManualView addSubview:sectionName];
    
    // section repetitions
    if ([section.repetitions integerValue] > 1) {
        UIFont *repetitionsFont = [UIFont fontWithName:@"HelveticaNeue" size:20];
        
        UILabel *sectionLength = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 190, 30)];
        sectionLength.text = [NSString stringWithFormat:@"repeat %ld times", [section.repetitions integerValue]];
        sectionLength.backgroundColor = [UIColor clearColor];
        sectionLength.textColor = [UIColor colorWithRed:250.0/255.0 green:105.0/255.0 blue:0.0/255.0 alpha:1.0];
        sectionLength.textAlignment = NSTextAlignmentRight;
        sectionLength.font = repetitionsFont;
        [headerManualView addSubview:sectionLength];
    }
    return headerManualView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionActivity* activity = [self getSectionActivity:indexPath];
    int detailsLen = 0;
    int lenDetailsLen = 0;
    
    if (activity.lenDetails.length > 0){
        UIFont *detailsFont = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        CGRect rect = [self sizeOfLabel:activity.lenDetails maxLabelWidth:300 font:detailsFont];
        lenDetailsLen = rect.size.height + 40;
    }
    
    //return MAX(MAX(detailsLen, lenDetailsLen), 40);
    return MAX(lenDetailsLen + 47, 47);
    //return 117;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"completeWorkout"]) {
        RWCompleteWorkoutViewController *controller = (RWCompleteWorkoutViewController *)segue.destinationViewController;
        controller.variant = self.variant;
    } else if ([[segue identifier] isEqualToString:@"goToCompleteTrainingScreenFromWorkoutDetails"]) {
        RWNewCompleteWorkoutViewController *destViewController = segue.destinationViewController;
        destViewController.workoutVariant = self.variant;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
	{
        [self.dataController addCompleteWorkoutEvent:variant];
        [self performSegueWithIdentifier:@"completeWorkout" sender:nil];
	}
}

- (IBAction)completeWorkoutClicked:(id)sender
{
    if (self.canComplete){
        [self performSegueWithIdentifier: @"goToCompleteTrainingScreenFromWorkoutDetails" sender: sender];
    } else {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Workout is already completed"
                                                             message:@"This workout is already completed in current plan so you cannot complete it."
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errorAlert show];
    }
}

- (CGFloat)heightForLabel:(UILabel*)label containingString:(NSString*)string
{
    float horizontalPadding = 10;
    float verticalPadding = 16;
    float kFontSize = 14;
    float widthOfTextView = label.bounds.size.width - horizontalPadding;
    float height = [string sizeWithFont:[UIFont systemFontOfSize:kFontSize] constrainedToSize:CGSizeMake(widthOfTextView, 999999.0f) lineBreakMode:NSLineBreakByWordWrapping].height + verticalPadding;
    
    return height;
}
@end
