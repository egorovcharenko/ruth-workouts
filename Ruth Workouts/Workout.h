//
//  Workout.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 14.05.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Plan, WorkoutVariant;

@interface Workout : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) int16_t number;
@property (nonatomic, retain) NSSet *childVariants;
@property (nonatomic, retain) Plan *parentPlan;
@end

@interface Workout (CoreDataGeneratedAccessors)

- (void)addChildVariantsObject:(WorkoutVariant *)value;
- (void)removeChildVariantsObject:(WorkoutVariant *)value;
- (void)addChildVariants:(NSSet *)values;
- (void)removeChildVariants:(NSSet *)values;

@end
