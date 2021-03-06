//
//  RWPlanDetailsViewController.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 26.05.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import "RWGeneralListController.h"
#import "Plan.h"


@interface RWPlanDetailsViewController : RWGeneralListController <UIActionSheetDelegate>
@property Plan* plan;
- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue;
- (IBAction)checkButtonClicked:(id)sender forEvent:(UIEvent *)event;
- (IBAction)scheduleClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@end
