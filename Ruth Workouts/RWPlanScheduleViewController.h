//
//  RWPlanScheduleViewController.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 06.06.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Plan.h"

@interface RWPlanScheduleViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>


@property Plan* plan;
@property (weak, nonatomic) IBOutlet UIDatePicker *nextTrainingDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *monButton;
@property (weak, nonatomic) IBOutlet UIButton *tueButton;
@property (weak, nonatomic) IBOutlet UIButton *wedButton;
@property (weak, nonatomic) IBOutlet UIButton *thuButton;
@property (weak, nonatomic) IBOutlet UIButton *friButton;
@property (weak, nonatomic) IBOutlet UIButton *satButton;
@property (weak, nonatomic) IBOutlet UIButton *sunButton;
@property (weak, nonatomic) IBOutlet UIPickerView *nextTrainingPicker;
- (IBAction)rescheduleButtonClicked:(id)sender;
- (IBAction)monClicked:(id)sender;
- (IBAction)tueClicked:(id)sender;
- (IBAction)wedClicked:(id)sender;
- (IBAction)thuClicked:(id)sender;
- (IBAction)friClicked:(id)sender;
- (IBAction)satClicked:(id)sender;
- (IBAction)sunClicked:(id)sender;
@property int weekdaysSelected;

// uipickerview
@property (strong, nonatomic) NSMutableArray *workouts;

@end
