//
//  RWGeneralListController.m
//  
//
//  Created by Egor Ovcharenko on 01.06.13.
//
//

#import "RWGeneralListController.h"

@implementation RWGeneralListController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setDataController];
    [self initFetchController];
}

- (void)initFetchController
{
    // init fetch controller
    self.fetchResultsController = [self.dataController getAllWorkouts];
}

- (void)setDataController
{
    // data controller
    if (self.dataController == nil){
        self.dataController = [[RWDataController alloc]initWithAppDelegate:(RWAppDelegate*)[[UIApplication sharedApplication] delegate] fetchedControllerDelegate:self];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



@end
