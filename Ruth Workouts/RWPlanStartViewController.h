//
//  RWPlanStartViewController.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 18.05.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Plan.h"

@interface RWPlanStartViewController : UIViewController

@property (nonatomic, strong) Plan* plan;
- (IBAction)newStartDateSelected:(id)sender forEvent:(UIEvent *)event;
- (IBAction)monClicked:(id)sender;
- (IBAction)tueClicked:(id)sender;
- (IBAction)wedClicked:(id)sender;
- (IBAction)thuClicked:(id)sender;
- (IBAction)friClicked:(id)sender;
- (IBAction)satClicked:(id)sender;
- (IBAction)sunClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *monButton;
@property (weak, nonatomic) IBOutlet UIButton *tueButton;
@property (weak, nonatomic) IBOutlet UIButton *wedButton;
@property (weak, nonatomic) IBOutlet UIButton *thuButton;
@property (weak, nonatomic) IBOutlet UIButton *friButton;
@property (weak, nonatomic) IBOutlet UIButton *satButton;
@property (weak, nonatomic) IBOutlet UIButton *sunButton;

- (IBAction)createPlanClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


@end
