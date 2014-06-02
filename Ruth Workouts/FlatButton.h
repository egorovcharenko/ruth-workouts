//
//  FlatButton.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 01.06.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlatButton : UIButton
@property(strong, nonatomic)UIColor *myColor;
-(id)initWithFrame:(CGRect)frame withBackgroundColor:(UIColor*)backgroundColor;
@end