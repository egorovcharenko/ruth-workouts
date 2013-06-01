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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionNumber
{
    NSArray *sections = [variant.childSections allObjects];
    Section *section = sections [sectionNumber];
    return [section.childActivities count];
}

- (void)configureCell:(RWActivityCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sections = [variant.childSections allObjects];
    Section *section = sections [indexPath.section];
 
    NSArray *activities = [section.childActivities allObjects];
    SectionActivity *activity = activities [indexPath.row];
    
    cell.detailsLabel.text = activity.details;
    cell.lenDetailsLabel.text = activity.lenDetails;
    
    // set len label
    NSString *firstPart = [NSString stringWithFormat:@"%d x", activity.lenMultiplier];
    NSString *secondPart = [NSString stringWithFormat:@"%d", activity.len];
    NSString *thirdPart = @"m";
    
    NSString *text = [NSString stringWithFormat:@"%@%@%@",
                      firstPart,
                      secondPart,
                      thirdPart];
    
    
    // Define general attributes for the entire text
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: cell.lenLabel.textColor,
                              NSFontAttributeName: cell.lenLabel.font
                              };
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:text
                                           attributes:attribs];
    
    UIColor *grayTextColor = [UIColor colorWithWhite:60.0/255.0 alpha:1.0];
    UIColor *cyanTextColor = [UIColor colorWithRed:74.0/255.0 green:187.0/255.0 blue:209.0/255.0 alpha:1.0];
    
    // Red text attributes
    NSRange redTextRange = [text rangeOfString:firstPart];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:grayTextColor}
                            range:redTextRange];
    
    // Green text attributes
    NSRange greenTextRange = [text rangeOfString:secondPart];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:cyanTextColor}
                            range:greenTextRange];
    
    // Purple and bold text attributes
    UIFont *boldFont = [UIFont boldSystemFontOfSize:cell.lenLabel.font.pointSize];
    NSRange purpleBoldTextRange = [text rangeOfString:thirdPart];
    
    [attributedText setAttributes:@{NSForegroundColorAttributeName:grayTextColor,
              NSFontAttributeName:boldFont}
                            range:purpleBoldTextRange];
    
    cell.lenLabel.attributedText = attributedText;
    
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
    NSArray *sections = [variant.childSections allObjects];
    Section *section = sections [sectionNumber];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    
    //allocate the view if it doesn't exist yet
    UIView* headerManualView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    
    // add gradient on the background
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = headerManualView.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       [(id)[UIColor colorWithWhite:67.0/255.0 alpha:1.0]CGColor],
                       [(id)[UIColor colorWithWhite:84.0/255.0 alpha:1.0]CGColor],
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

@end
