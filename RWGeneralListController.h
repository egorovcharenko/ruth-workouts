//
//  RWGeneralListController.h
//  
//
//  Created by Egor Ovcharenko on 01.06.13.
//
//

#import <UIKit/UIKit.h>

#import "RWDataController.h"
#import "RWWorkoutCell.h"

@interface RWGeneralListController : UITableViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITextFieldDelegate>

- (void)initFetchController;

- (void)setDataController;

// data access
@property RWDataController* dataController;
// cache
@property NSFetchedResultsController *fetchResultsController;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (CGRect) sizeOfLabel:(NSString*)text maxLabelWidth:(NSInteger)maxLabelWidth font:(UIFont*)font;

@end
