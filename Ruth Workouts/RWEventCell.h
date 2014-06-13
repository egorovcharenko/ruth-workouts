//
//  RWEventCell.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 13.06.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWEventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *planAndWorkoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestLapLabel;
@property (weak, nonatomic) IBOutlet UILabel *lenAndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end
