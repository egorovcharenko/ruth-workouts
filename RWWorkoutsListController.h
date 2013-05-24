//
//  RWWorkoutsListController.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 21.05.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RWDetailViewController;

@interface RWWorkoutsListController : UITableViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) RWDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
