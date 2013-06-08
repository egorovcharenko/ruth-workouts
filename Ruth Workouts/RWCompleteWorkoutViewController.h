//
//  RWCompleteWorkoutViewController.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 08.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WorkoutVariant.h"

@interface RWCompleteWorkoutViewController : UIViewController

@property WorkoutVariant *variant;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)shareTwitterButtonClicked:(id)sender;
- (IBAction)shareFacebookButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareFBButton;
@property (weak, nonatomic) IBOutlet UIButton *shareTwitterButton;

@end
