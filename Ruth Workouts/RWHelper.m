//
//  RWHelper.m
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 13.06.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import "RWHelper.h"

@implementation RWHelper

+ (RWHelper *)sharedInstance
{
    static RWHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RWHelper alloc] init];

        
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        
        self.aoi = [UIColor colorWithRed:105.0/255.0 green:210.0/255.0 blue:231.0/255.0 alpha:1.0];
        self.cleanPoundwater = [UIColor colorWithRed:167.0/255.0 green:219.0/255.0 blue:216.0/255.0 alpha:1.0];
        self.beachStorm = [UIColor colorWithRed:224.0/255.0 green:228.0/255.0 blue:204.0/255.0 alpha:1.0];
        self.giantGoldfish = [UIColor colorWithRed:243.0/255.0 green:134.0/255.0 blue:48.0/255.0 alpha:1.0];
        self.unrealFoodPills = [UIColor colorWithRed:250.0/255.0 green:105.0/255.0 blue:0 alpha:1.0];
        
        // fonts
        self.boldFont15 = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        self.thinFont15 = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15];
        
        self.boldFont17 = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        self.thinFont17 = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
        
        self.boldFont20 = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        self.thinFont20 = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
        
        self.boldFont24 = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
        self.thinFont24 = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
        
        // styles
        self.lengthStyle = [[RWStyle alloc] init];
        self.lengthStyle.color = self.giantGoldfish;
        self.lengthStyle.font = self.boldFont20;
        
        self.metersStyle = [[RWStyle alloc] init];
        self.metersStyle.color = self.giantGoldfish;
        self.metersStyle.font = self.thinFont20;
        
        self.hoursStyle = [[RWStyle alloc] init];
        self.hoursStyle.color = self.giantGoldfish;
        self.hoursStyle.font = self.boldFont20;
        
        self.timeDots = [[RWStyle alloc] init];
        self.timeDots.color = self.giantGoldfish;
        self.timeDots.font = self.thinFont20;
        
        self.grayLengthStyle = [[RWStyle alloc] init];
        self.grayLengthStyle.color = [UIColor lightGrayColor];
        self.grayLengthStyle.font = self.boldFont20;
        
        self.grayMetersStyle = [[RWStyle alloc] init];
        self.grayMetersStyle.color = [UIColor lightGrayColor];
        self.grayMetersStyle.font = self.thinFont20;
        
        self.smallGrayLengthStyle = [[RWStyle alloc] init];
        self.smallGrayLengthStyle.color = [UIColor darkGrayColor];
        self.smallGrayLengthStyle.font = self.boldFont15;
        
        self.smallGrayMetersStyle = [[RWStyle alloc] init];
        self.smallGrayMetersStyle.color = [UIColor darkGrayColor];
        self.smallGrayMetersStyle.font = self.thinFont15;
        
        self.minutesStyle = self.hoursStyle;
        self.secondsStyle = self.hoursStyle;
        self.millisecondsStyle = self.hoursStyle;
        
        self.aoiThickStyle = [[RWStyle alloc] init];
        self.aoiThickStyle.color = self.aoi;
        self.aoiThickStyle.font = self.boldFont17;
        
        self.aoiThinStyle = [[RWStyle alloc] init];
        self.aoiThinStyle.color = self.aoi;
        self.aoiThinStyle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


+ (NSMutableAttributedString*) prepareAttributedString:(NSArray*) dict
{
    // dict - NSString -> style
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@""];
    for (RWStringStylePair* pair in dict) {
        RWStyle * style = pair.style;
        NSMutableAttributedString * subString = [[NSMutableAttributedString alloc] initWithString:pair.text];
        [subString setAttributes:@{NSFontAttributeName:style.font, NSForegroundColorAttributeName:style.color} range:NSMakeRange(0, pair.text.length)];
        [string appendAttributedString:subString];
    }
    return string;
}

- (NSMutableAttributedString*) prepareTimeString:(double) time mainStyle:(RWStyle*)mainStyle thinStyle:(RWStyle*)thinStyle
{
    // show minutes and seconds
    long hours = (int)time / (60 * 60);
    long minutes = ((int)time % (60 * 60)) / 60;
    long seconds = time - minutes * 60 - hours * 60 * 60;
    
    NSMutableArray *pairs = [[NSMutableArray alloc] init];
    RWStringStylePair* pair;
    if (hours > 0) {
        pair = [[RWStringStylePair alloc] init];
        pair.style = mainStyle;
        pair.text = [NSString stringWithFormat:@"%ld",hours];
        [pairs addObject:pair];
        
        pair = [[RWStringStylePair alloc] init];
        pair.style = thinStyle;
        pair.text = [NSString stringWithFormat:@":"];
        [pairs addObject:pair];
        
        pair = [[RWStringStylePair alloc] init];
        pair.style = mainStyle;
        pair.text = [NSString stringWithFormat:@"%02ld", minutes];
        [pairs addObject:pair];
        
        pair = [[RWStringStylePair alloc] init];
        pair.style = thinStyle;
        pair.text = [NSString stringWithFormat:@":"];
        [pairs addObject:pair];
        
        pair = [[RWStringStylePair alloc] init];
        pair.style = mainStyle;
        pair.text = [NSString stringWithFormat:@"%02ld", seconds];
        [pairs addObject:pair];
    } else {
        pair = [[RWStringStylePair alloc] init];
        pair.style = mainStyle;
        pair.text = [NSString stringWithFormat:@"%ld", minutes];
        [pairs addObject:pair];
        
        pair = [[RWStringStylePair alloc] init];
        pair.style = thinStyle;
        pair.text = [NSString stringWithFormat:@":"];
        [pairs addObject:pair];
        
        pair = [[RWStringStylePair alloc] init];
        pair.style = mainStyle;
        pair.text = [NSString stringWithFormat:@"%02ld", seconds];
        [pairs addObject:pair];
    }
        
    NSMutableAttributedString* attributedText = [RWHelper prepareAttributedString:pairs];
    
    // general attributes for the entire text
    return attributedText;
}

- (NSMutableAttributedString *)prepareLenAndTimeAttributedString:(int) len time: (double) time grayStyle:(bool) grayStyle
{
    
    if ((time < 0.001) && (len == 0)){
        return [[NSMutableAttributedString alloc] init];
    }
    
    RWStyle *mainStyle;
    RWStyle *thinStyle;
    
    if (!grayStyle){
        mainStyle = [RWHelper sharedInstance].lengthStyle;
        thinStyle = [RWHelper sharedInstance].metersStyle;
    } else {
        mainStyle = [RWHelper sharedInstance].grayLengthStyle;
        thinStyle = [RWHelper sharedInstance].grayMetersStyle;
    }
    
    // total len or time
    NSAttributedString* lenAttrString;
    NSAttributedString* timeAttrString;
    NSMutableAttributedString* resultingLenAndTimeAttrString = [[NSMutableAttributedString alloc] init];
    
    if (len > 0) {
        NSMutableArray *pairs = [[NSMutableArray alloc] init];
        RWStringStylePair* pair;
        
        pair = [[RWStringStylePair alloc] init];
        pair.style = mainStyle;
        pair.text = [NSString stringWithFormat:@"%d", len];
        [pairs addObject:pair];
        
        pair = [[RWStringStylePair alloc] init];
        pair.style = thinStyle;
        pair.text = @"m";
        [pairs addObject:pair];

        lenAttrString = [RWHelper prepareAttributedString:pairs];
    }
    
    if (time > 0.01) {
        timeAttrString = [[RWHelper sharedInstance] prepareTimeString:time mainStyle:mainStyle thinStyle:thinStyle];
    }
    
    if ((lenAttrString.length > 0) && (timeAttrString.length > 0)){
        // prepare "of" string
        NSMutableArray *pairs = [[NSMutableArray alloc] init];
        RWStringStylePair* pair;
        
        pair = [[RWStringStylePair alloc] init];
        pair.style = thinStyle;
        pair.text = @" in ";
        [pairs addObject:pair];
        
        NSAttributedString* ofAttrString = [RWHelper prepareAttributedString:pairs];
        
        [resultingLenAndTimeAttrString appendAttributedString:lenAttrString];
        [resultingLenAndTimeAttrString appendAttributedString:ofAttrString];
        [resultingLenAndTimeAttrString appendAttributedString:timeAttrString];
        
    } else if (lenAttrString.length > 0) {
        [resultingLenAndTimeAttrString appendAttributedString:lenAttrString];
    } else {
        [resultingLenAndTimeAttrString appendAttributedString:timeAttrString];
    }
    return resultingLenAndTimeAttrString;
}

@end
