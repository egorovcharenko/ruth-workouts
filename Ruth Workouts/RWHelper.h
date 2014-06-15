//
//  RWHelper.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 13.06.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWStyle.h"
#import "RWStringStylePair.h"

@interface RWHelper : NSObject

+ (NSMutableAttributedString*) prepareAttributedString:(NSArray*) dict;
- (NSMutableAttributedString*) prepareTimeString:(double)time mainStyle:(RWStyle*)mainStyle thinStyle:(RWStyle*)thinStyle;
- (NSMutableAttributedString *)prepareLenAndTimeAttributedString:(int) len time: (double) time grayStyle:(bool) grayStyle;

+ (RWHelper *) sharedInstance;
@property UIColor* aoi;
@property UIColor* cleanPoundwater;
@property UIColor* beachStorm;
@property UIColor* giantGoldfish;
@property UIColor* unrealFoodPills;

// len styles
@property RWStyle* lengthStyle;
@property RWStyle* metersStyle;
@property RWStyle* grayLengthStyle;
@property RWStyle* grayMetersStyle;
@property RWStyle* smallGrayLengthStyle;
@property RWStyle* smallGrayMetersStyle;
@property RWStyle* aoiThickStyle;
@property RWStyle* aoiThinStyle;
@property RWStyle* swimThickStyle;
@property RWStyle* swimThinStyle;

// time styles
@property RWStyle* hoursStyle;
@property RWStyle* minutesStyle;
@property RWStyle* secondsStyle;
@property RWStyle* millisecondsStyle;
@property RWStyle* timeDots;

// fonts
@property UIFont *boldFont15;
@property UIFont *thinFont15;
@property UIFont *boldFont17;
@property UIFont *thinFont17;
@property UIFont *boldFont20;
@property UIFont *thinFont20;
@property UIFont *boldFont24;
@property UIFont *thinFont24;

// weekday
+ (NSUInteger)getWeekday:(NSDate *)date;
@end