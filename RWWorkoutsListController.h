//
//  RWWorkoutsListController.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 21.05.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RWDataController;

#import "RWGeneralListController.h"

@interface RWWorkoutsListController : RWGeneralListController 

// variant buttons
- (IBAction)firstVariantClicked:(id)sender forEvent:(UIEvent *)event;
- (IBAction)secondVariantClicked:(id)sender forEvent:(UIEvent *)event;


@end
