//
//  RWPlanDetailsViewController.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 26.05.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import "RWGeneralListController.h"
#import "Plan.h"


@interface RWPlanDetailsViewController : RWGeneralListController
@property Plan* plan;
- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue;
- (IBAction)checkButtonClicked:(id)sender forEvent:(UIEvent *)event;

@end
