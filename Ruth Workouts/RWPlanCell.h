//
//  RWPlanCell.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 14.05.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWPlanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *nextTrainingLabel;
@property (weak, nonatomic) IBOutlet UILabel *workoutsProgress;
@property (weak, nonatomic) IBOutlet UILabel *workoutsStaticSign;


@end
