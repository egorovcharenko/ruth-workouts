//
//  RWPlanWorkoutCell.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 26.05.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWPlanWorkoutCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *workoutName;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lenLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@end
