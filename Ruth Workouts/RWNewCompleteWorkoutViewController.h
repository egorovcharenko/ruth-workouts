//
//  RWNewCompleteWorkoutViewController.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 01.06.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutVariant.h"

@interface RWNewCompleteWorkoutViewController : UIViewController <UITextFieldDelegate>

@property WorkoutVariant *workoutVariant;

@property (weak, nonatomic) IBOutlet UITextField *totalDistanceText;
@property (weak, nonatomic) IBOutlet UITextField *totalTimeText;
@property (weak, nonatomic) IBOutlet UITextField *bestLapTimeText;
- (IBAction)shareOnFacebook:(id)sender;
- (IBAction)saveClicked:(id)sender;
- (IBAction)shareOnTwitter:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property bool returnToWorkoutsList;

@end
