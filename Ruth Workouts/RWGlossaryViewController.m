//
//  RWGlossaryViewController.m
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 09.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import "RWGlossaryViewController.h"

#import "GlossaryTermin.h" 
#import "GlossaryTopic.h"

#import "RWGlossaryCell.h"

@interface RWGlossaryViewController ()

@end

@implementation RWGlossaryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initFetchController
{
    // init fetch controller
    self.fetchResultsController = [self.dataController getAllGlossaryTopics];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchResultsController.fetchedObjects count];
}

- (GlossaryTopic*) getTopic:(NSInteger)sectionNumber
{
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]];
    
    NSArray *sortedTopics = [self.fetchResultsController.fetchedObjects sortedArrayUsingDescriptors:sortDescriptors];
    
    return sortedTopics[sectionNumber];
}

- (GlossaryTermin *)getGlossaryTermin:(NSIndexPath *)indexPath
{
    GlossaryTopic* topic = [self getTopic:indexPath.section];
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]];
    NSArray *sortedTermins = [[topic.topicTermins allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    
    return sortedTermins [indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GlossaryTopic *topic = [self getTopic:section];
    return [topic.topicTermins count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWGlossaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(RWGlossaryCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //GlossaryTopic *topic = [self getTopic:indexPath.section];
    GlossaryTermin *termin = [self getGlossaryTermin:indexPath];
    
    cell.terminNameLabel.text = termin.name;
    cell.terminDefinitionLabel.text = termin.definition;
    
    // shrink label
    
    [cell.terminNameLabel sizeToFit];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionNumber
{
    GlossaryTopic *topic = [self getTopic:sectionNumber];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    
    //allocate the view if it doesn't exist yet
    UIView* headerManualView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    
    // font
    UIFont *yourFont = [UIFont fontWithName:@"Helvetica-Bold" size:[UIFont systemFontSize]];
    
    // section name
    UILabel *topicName = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, width, 20)];
    topicName.text = topic.name;
    topicName.backgroundColor = [UIColor clearColor];
    topicName.textColor = [UIColor colorWithRed:245.0/255.0 green:99.0/255.0 blue:32.0/255.0 alpha:1.0];
    topicName.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:0.8];
    topicName.textAlignment = NSTextAlignmentLeft;
    topicName.font = yourFont;
    [headerManualView addSubview:topicName];
        
    return headerManualView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GlossaryTermin *termin = [self getGlossaryTermin:indexPath];
    
    UIFont *detailsFont = [UIFont systemFontOfSize:14];
    CGRect rect = [self sizeOfLabel:termin.definition maxLabelWidth:220 font:detailsFont];
    return rect.size.height + 25;
}


@end
