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
    self.fetchResultsController = [self.dataController getAllWorkouts];
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
    
    // swim button
    [cell.activityNameButton setTitle:activity.name forState:UIControlStateNormal];
    [cell.activityNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIEdgeInsets edge = UIEdgeInsetsMake(13, 13, 14, 13);
    UIImage *tasks_top = [UIImage imageNamed:@"orange_button"];
    UIImage *stretchableImage = [tasks_top resizableImageWithCapInsets:edge];
    [cell.activityNameButton setBackgroundImage:stretchableImage forState:UIControlStateNormal];
    CGRect rect = [self sizeOfLabel:activity.name maxLabelWidth:999 font:nil];
    cell.detailsButtonWidthConstraint.constant = rect.size.width + 26;
    
    // length label
    NSString *firstPart = [NSString stringWithFormat:@"%d x ", activity.lenMultiplier];
    NSString *secondPart = [NSString stringWithFormat:@"%d", activity.len];
    NSString *thirdPart = @"";
    
    // set len label
    if (activity.lenMultiplier == 1){
        firstPart = @"";
    }
    NSString *text = [NSString stringWithFormat:@"%@%@%@",
                      firstPart,
                      secondPart,
                      thirdPart];
    // Define general attributes for the entire text
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: [cell.lenButton titleColorForState:UIControlStateNormal],
                              NSFontAttributeName: cell.lenButton.titleLabel.font
                              };
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:text
                                           attributes:attribs];
    UIColor *grayTextColor = [UIColor colorWithWhite:60.0/255.0 alpha:1.0];
    UIColor *cyanTextColor = grayTextColor;// [UIColor colorWithRed:74.0/255.0 green:187.0/255.0 blue:209.0/255.0 alpha:1.0];
    // Red text attributes
    NSRange redTextRange = [text rangeOfString:firstPart];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:grayTextColor}
                            range:redTextRange];
    
    // Green text attributes
    NSRange greenTextRange = [text rangeOfString:secondPart];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:cyanTextColor}
                            range:greenTextRange];
    
    // Purple and bold text attributes
    //UIFont *boldFont = [UIFont boldSystemFontOfSize:cell.lenLabel.font.pointSize];
    NSRange purpleBoldTextRange = [text rangeOfString:thirdPart];
    
    [attributedText setAttributes:@{NSForegroundColorAttributeName:grayTextColor
     //,NSFontAttributeName:boldFont
     }
    range:purpleBoldTextRange];
    
    //cell.lenLabel.attributedText = attributedText;
    
    // len button
    {
        UIEdgeInsets edge = UIEdgeInsetsMake(5, 5, 5, 5);
        UIImage *tasks_top = [UIImage imageNamed:@"blue_button"];
        UIImage *stretchableImage = [tasks_top resizableImageWithCapInsets:edge];
        [cell.lenButton setBackgroundImage:stretchableImage forState:UIControlStateNormal];
        //[cell.lenButton setAttributedTitle:attributedText forState:UIControlStateNormal];
        [cell.lenButton setTitle:[attributedText string] forState:UIControlStateNormal];
        //CGRect rect = [self sizeOfLabel:[attributedText string] maxLabelWidth:999];
        //cell.lenButtonWidthConstraint.constant = rect.size.width + 10;
    }
    
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
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = headerManualView.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithWhite:67.0/255.0 alpha:1.0]CGColor],
                       (id)[[UIColor colorWithWhite:84.0/255.0 alpha:1.0]CGColor],
                       nil];
    [headerManualView.layer addSublayer:gradient];
    
    // font
    UIFont *yourFont = [UIFont fontWithName:@"Helvetica-Bold" size:[UIFont systemFontSize]];

    // section name
    UILabel *sectionName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    sectionName.text = section.name;
    sectionName.backgroundColor = [UIColor clearColor];
    sectionName.textColor = [UIColor whiteColor];
    sectionName.textAlignment = NSTextAlignmentCenter;
    sectionName.font = yourFont;
    [headerManualView addSubview:sectionName];
    
    // section length
    UILabel *sectionLength = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 64, 30)];
    sectionLength.text = [NSString stringWithFormat:@"%d m", section.length]; // calculate on the fly
    sectionLength.backgroundColor = [UIColor clearColor];
    sectionLength.textColor = [UIColor whiteColor];
    sectionLength.textAlignment = NSTextAlignmentCenter;
    sectionLength.font = yourFont;
    [headerManualView addSubview:sectionLength];
    
    return headerManualView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionActivity* activity = [self getSectionActivity:indexPath];
    
    if (activity.details.length > 0){
        UIFont *detailsFont = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        CGRect rect = [self sizeOfLabel:activity.details maxLabelWidth:150 font:detailsFont];
        return rect.size.height + 40;
    } else {
        return 40;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"completeWorkout"]) {
        RWCompleteWorkoutViewController *controller = (RWCompleteWorkoutViewController *)segue.destinationViewController;
        controller.variant = self.variant;
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                    message:@"Have you really completed this workout?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    [alert addButtonWithTitle:@"It's completed"];
    [alert show];
}
@end
