//
//  WorkoutVariant.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 02.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Section, Workout, WorkoutVariantEvent;

@interface WorkoutVariant : NSManagedObject

@property (nonatomic) int16_t length;
@property (nonatomic, retain) NSString * tips;
@property (nonatomic, retain) NSSet *childSections;
@property (nonatomic, retain) Workout *parentWorkout;
@property (nonatomic, retain) NSSet *variantEvents;
@end

@interface WorkoutVariant (CoreDataGeneratedAccessors)

- (void)addChildSectionsObject:(Section *)value;
- (void)removeChildSectionsObject:(Section *)value;
- (void)addChildSections:(NSSet *)values;
- (void)removeChildSections:(NSSet *)values;

- (void)addVariantEventsObject:(WorkoutVariantEvent *)value;
- (void)removeVariantEventsObject:(WorkoutVariantEvent *)value;
- (void)addVariantEvents:(NSSet *)values;
- (void)removeVariantEvents:(NSSet *)values;

@end
