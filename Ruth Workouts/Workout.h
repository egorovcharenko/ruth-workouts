//
//  Workout.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 02.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WorkoutVariant;

@interface Workout : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) int16_t number;
@property (nonatomic, retain) NSSet *childVariants;
@end

@interface Workout (CoreDataGeneratedAccessors)

- (void)addChildVariantsObject:(WorkoutVariant *)value;
- (void)removeChildVariantsObject:(WorkoutVariant *)value;
- (void)addChildVariants:(NSSet *)values;
- (void)removeChildVariants:(NSSet *)values;

@end
