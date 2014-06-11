//
//  WorkoutVariantEvent.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 12.06.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WorkoutVariant;

@interface WorkoutVariantEvent : NSManagedObject

@property (nonatomic, retain) NSNumber * bestLapTime;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * totalLength;
@property (nonatomic, retain) NSNumber * totalTime;
@property (nonatomic, retain) WorkoutVariant *parentVariant;

@end
