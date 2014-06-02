//
//  WorkoutVariant.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 01.06.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Section, Workout, WorkoutVariantEvent;

@interface WorkoutVariant : NSManagedObject

@property (nonatomic, retain) NSNumber * length;
@property (nonatomic, retain) NSNumber * number;
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
