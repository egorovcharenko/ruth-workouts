//
//  RWActivityCell.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 01.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lenLabel;
@property (weak, nonatomic) IBOutlet UILabel *lenDetailsLabel;

@end
