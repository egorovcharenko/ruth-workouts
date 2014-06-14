//
//  RWWorkoutDetailsController.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 01.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import "RWWorkoutsListController.h"

#import "WorkoutVariant.h"

@interface RWWorkoutDetailsController : RWGeneralListController

@property WorkoutVariant* variant;
@property bool canComplete;
@property bool comeFromListOfWorkouts;
- (IBAction)completeWorkoutClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *completeButton;

@end
