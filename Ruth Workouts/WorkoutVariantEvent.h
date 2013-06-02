//
//  WorkoutVariantEvent.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 02.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WorkoutVariant;

@interface WorkoutVariantEvent : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic) NSTimeInterval date;
@property (nonatomic) int16_t totalLength;
@property (nonatomic, retain) WorkoutVariant *planVariant;

@end
