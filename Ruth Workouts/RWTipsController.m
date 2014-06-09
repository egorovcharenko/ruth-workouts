//
//  RWTipsController.m
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 08.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import "RWTipsController.h"

#import "Tip.h"

#import "RWTipsCell.h"

@interface RWTipsController ()

@end

@implementation RWTipsController

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = (int)[self.fetchResultsController.fetchedObjects count];
    return count;
}

- (void)initFetchController
{
    // init fetch controller
    self.fetchResultsController = [self.dataController getAllTips];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWTipsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(RWTipsCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Tip *tip = [self.fetchResultsController objectAtIndexPath:indexPath];
    
    cell.tipNumberLabel.text = [NSString stringWithFormat:@"# %d", tip.number];;
    cell.tipTextLabel.text = tip.text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tip *tip = [self.fetchResultsController objectAtIndexPath:indexPath];
    
    UIFont *detailsFont = [UIFont fontWithName:@"Helvetica" size:17];
    CGRect rect = [self sizeOfLabel:tip.text maxLabelWidth:242 font:detailsFont];
    return rect.size.height + 25;
}

- (IBAction)glossaryClicked:(id)sender {
    [self performSegueWithIdentifier:@"goToGlossary" sender:sender];
}
@end
