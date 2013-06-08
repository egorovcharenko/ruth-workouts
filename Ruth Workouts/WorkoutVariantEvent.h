//
//  WorkoutVariantEvent.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 08.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WorkoutVariant;

@interface WorkoutVariantEvent : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * totalLength;
@property (nonatomic, retain) WorkoutVariant *planVariant;

@end
