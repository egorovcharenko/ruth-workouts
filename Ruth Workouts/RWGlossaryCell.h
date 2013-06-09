//
//  RWGlossaryCell.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 09.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWGlossaryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *terminNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *terminDefinitionLabel;

@end
